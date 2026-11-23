module HouseRulesTest exposing (suite)

import Dict
import Expect
import Factors exposing (allFactors)
import Fixtures exposing (emptyModel)
import HouseRules exposing (Effect(..), Option(..))
import Seeds exposing (allSeeds)
import Test exposing (Test, describe, test)
import Types exposing (..)



-- One change of each kind, touching a seed factor, a seed and a global factor.


sampleChanges : List HouseRules.Change
sampleChanges =
    [ { description = "Adds attended objects to Animate", effect = Adds attended }
    , { description = "Removes Afflict", effect = Removes (SeedOption Afflict) }
    , { description = "Replaces range with area"
      , effect = Replaces (GlobalFactorOption IncreaseRange) (GlobalFactorOption IncreaseArea)
      }
    ]


attended : Option
attended =
    SeedFactorOption Animate "animate_attended"


instanceOf : SeedId -> Int -> List AppliedSeedFactor -> SeedInstance
instanceOf seedId iid seedFactors =
    { instanceId = iid
    , seedId = seedId
    , appliedSeedFactors = seedFactors
    , choices = Dict.empty
    , baseDCOverride = Nothing
    }


{-| A spell using every option the sample changes touch, plus one they don't.
-}
spell : Model
spell =
    { emptyModel
        | seedInstances =
            [ instanceOf Afflict 0 []
            , instanceOf Animate 1 [ { factorId = "animate_attended", quantity = 1 } ]
            , instanceOf Afflict 2 []
            ]
        , nextInstanceId = 3
        , primarySeedInstanceId = Just 0
        , appliedFactors =
            [ { factorId = IncreaseRange, quantity = 2 }
            , { factorId = IncreaseArea, quantity = 1 }
            , { factorId = Dismissible, quantity = 1 }
            ]
    }


{-| A spell whose only seed the sample changes remove.
-}
onlyAfflict : Model
onlyAfflict =
    { emptyModel
        | seedInstances = [ instanceOf Afflict 0 [ { factorId = "afflict_rolls", quantity = 2 } ] ]
        , nextInstanceId = 1
        , primarySeedInstanceId = Just 0
        , appliedFactors =
            [ { factorId = Dismissible, quantity = 1 }
            , { factorId = TargetToArea, quantity = 1 }
            ]
        , targetToAreaShape = Just "Cylinder"
    }


{-| Every seed with every one of its seed factors, and every global factor.
-}
everything : Model
everything =
    { emptyModel
        | seedInstances =
            List.indexedMap
                (\i seed ->
                    instanceOf seed.id
                        i
                        (List.map (\sf -> { factorId = sf.id, quantity = 1 })
                            (seed.universalFactors ++ List.concatMap .factors seed.modes)
                        )
                )
                allSeeds
        , appliedFactors = List.map (\f -> { factorId = f.id, quantity = 1 }) allFactors
    }


suite : Test
suite =
    describe "HouseRules"
        [ describe "offered"
            [ test "with house rules on, removed and replaced options are withdrawn" <|
                \_ ->
                    [ attended, SeedOption Afflict, GlobalFactorOption IncreaseRange, GlobalFactorOption IncreaseArea ]
                        |> List.map (HouseRules.offered sampleChanges True)
                        |> Expect.equal [ True, False, False, True ]
            , test "with house rules off, added and replacement options are withdrawn" <|
                \_ ->
                    [ attended, SeedOption Afflict, GlobalFactorOption IncreaseRange, GlobalFactorOption IncreaseArea ]
                        |> List.map (HouseRules.offered sampleChanges False)
                        |> Expect.equal [ False, True, True, False ]
            ]
        , describe "affected"
            [ test "turning house rules on affects the removed and replaced options in use" <|
                \_ ->
                    HouseRules.affected sampleChanges True spell
                        |> Expect.equal [ SeedOption Afflict, GlobalFactorOption IncreaseRange ]
            , test "turning house rules off affects the added and replacement options in use" <|
                \_ ->
                    HouseRules.affected sampleChanges False spell
                        |> Expect.equal [ attended, GlobalFactorOption IncreaseArea ]
            , test "withdrawing the last seed also lists the global factors that go with it, but not its own seed factors" <|
                \_ ->
                    HouseRules.affected sampleChanges True onlyAfflict
                        |> Expect.equal [ SeedOption Afflict, GlobalFactorOption Dismissible, GlobalFactorOption TargetToArea ]
            , test "options the spell doesn't use are never affected" <|
                \_ ->
                    HouseRules.affected sampleChanges True emptyModel
                        |> Expect.equal []
            ]
        , describe "reset"
            [ test "turning on resets every Afflict instance and the replaced factor, and nothing else" <|
                \_ ->
                    let
                        after =
                            HouseRules.reset (HouseRules.affected sampleChanges True spell) spell
                    in
                    ( List.map .instanceId after.seedInstances, after.primarySeedInstanceId, after.appliedFactors )
                        |> Expect.equal
                            ( [ 1 ]
                            , Just 1
                            , [ { factorId = IncreaseArea, quantity = 1 }, { factorId = Dismissible, quantity = 1 } ]
                            )
            , test "turning off resets the added seed factor and the replacement factor, and nothing else" <|
                \_ ->
                    let
                        after =
                            HouseRules.reset (HouseRules.affected sampleChanges False spell) spell
                    in
                    ( List.map (\i -> ( i.instanceId, i.appliedSeedFactors )) after.seedInstances, after.appliedFactors )
                        |> Expect.equal
                            ( [ ( 0, [] ), ( 1, [] ), ( 2, [] ) ]
                            , [ { factorId = IncreaseRange, quantity = 2 }, { factorId = Dismissible, quantity = 1 } ]
                            )
            ]
        , describe "dropUnoffered"
            [ test "a spell loaded with house rules on loses the removed and replaced options" <|
                \_ ->
                    let
                        after =
                            HouseRules.dropUnoffered sampleChanges { spell | houseRules = True }
                    in
                    ( List.map .seedId after.seedInstances, List.map .factorId after.appliedFactors, after.houseRules )
                        |> Expect.equal ( [ Animate ], [ IncreaseArea, Dismissible ], True )
            , test "a spell loaded with house rules off loses the added and replacement options" <|
                \_ ->
                    let
                        after =
                            HouseRules.dropUnoffered sampleChanges { spell | houseRules = False }
                    in
                    ( List.concatMap .appliedSeedFactors after.seedInstances, List.map .factorId after.appliedFactors, after.houseRules )
                        |> Expect.equal ( [], [ IncreaseRange, Dismissible ], False )
            , test "the campaign's change list leaves every option in place" <|
                \_ ->
                    [ HouseRules.dropUnoffered HouseRules.changes { everything | houseRules = True }
                    , HouseRules.dropUnoffered HouseRules.changes { everything | houseRules = False }
                    ]
                        |> List.map (\m -> ( m.seedInstances, m.appliedFactors ))
                        |> Expect.equal
                            [ ( everything.seedInstances, everything.appliedFactors )
                            , ( everything.seedInstances, everything.appliedFactors )
                            ]
            ]
        , describe "the campaign's change list"
            [ test "affects nothing when turning house rules on" <|
                \_ ->
                    HouseRules.affected HouseRules.changes True everything
                        |> Expect.equal []
            , test "affects nothing when turning house rules off" <|
                \_ ->
                    HouseRules.affected HouseRules.changes False everything
                        |> Expect.equal []
            ]
        , test "a seed factor is named after its seed" <|
            \_ ->
                HouseRules.optionName attended
                    |> Expect.equal "Animate: Animate attended objects"
        ]
