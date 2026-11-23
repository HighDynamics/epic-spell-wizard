module UrlStateTest exposing (suite)

import Dict
import Expect
import Factors exposing (allFactors)
import Fixtures exposing (emptyModel, seedInstance)
import Seeds exposing (allSeeds)
import Test exposing (Test, describe, test)
import Types exposing (..)
import UrlState


roundTrip : Model -> Model
roundTrip model =
    UrlState.applyQuery (UrlState.encode model) emptyModel



-- A link made before house rules existed.


oldLink : String
oldLink =
    "?name=Bob%27s%20Bolt%20%28big%29&school=Evocation&bolt=bolt-5x300&panels=011&primary=1&seeds=c%3A%3Aenergy_type%3DFire%3Aenergy_bolt_damage%3D4%3B0%3A12%3A%3A&factors=f%3D1%2Cs%3D3"



-- A spell that sets every field the link carries, with house rules off.


everyField : Model
everyField =
    { emptyModel
        | spellName = "Fireball"
        , selectedSchool = Just "Evocation"
        , selectedSavingThrow = Just { saveType = ReflexSave, effect = Half, harmless = False }
        , targetToAreaShape = Just "Cylinder"
        , personalToAreaShape = Just "20-ft. radius"
        , boltShape = Just "Bolt (5 ft. × 300 ft.)"
        , seedsPanelOpen = False
        , seedInstances =
            [ { instanceId = 0
              , seedId = Energy
              , appliedSeedFactors = []
              , choices = Dict.empty
              , baseDCOverride = Nothing
              }
            ]
        , nextInstanceId = 1
        , primarySeedInstanceId = Just 0
        , appliedFactors = [ { factorId = ChangeToBolt, quantity = 1 } ]
    }


suite : Test
suite =
    describe "UrlState"
        [ test "an empty spell round-trips" <|
            \_ -> roundTrip emptyModel |> Expect.equal emptyModel
        , test "a spell name with reserved characters round-trips" <|
            \_ ->
                let
                    name =
                        "Bob's \"Fire\" (Ball)! ~100% & more *"
                in
                (roundTrip { emptyModel | spellName = name }).spellName
                    |> Expect.equal name
        , test "every seed round-trips" <|
            \_ ->
                allSeeds
                    |> List.filter
                        (\seed ->
                            (roundTrip { emptyModel | seedInstances = [ seedInstance seed ] }).seedInstances
                                |> List.map .seedId
                                |> (/=) [ seed.id ]
                        )
                    |> List.map .id
                    |> Expect.equal []
        , test "every global factor round-trips" <|
            \_ ->
                allFactors
                    |> List.filter
                        (\factor ->
                            (roundTrip { emptyModel | appliedFactors = [ { factorId = factor.id, quantity = 2 } ] }).appliedFactors
                                |> (/=) [ { factorId = factor.id, quantity = 2 } ]
                        )
                    |> List.map .id
                    |> Expect.equal []
        , describe "house rules"
            [ test "round-trip when on" <|
                \_ ->
                    (roundTrip { emptyModel | spellName = "Fireball", houseRules = True }).houseRules
                        |> Expect.equal True
            , test "round-trip when off" <|
                \_ ->
                    (roundTrip { emptyModel | spellName = "Fireball" }).houseRules
                        |> Expect.equal False
            , test "add house=1 when on" <|
                \_ ->
                    UrlState.encode { emptyModel | spellName = "Fireball", houseRules = True }
                        |> Expect.equal "?name=Fireball&house=1"
            , test "add nothing when off" <|
                \_ ->
                    UrlState.encode { emptyModel | spellName = "Fireball" }
                        |> Expect.equal "?name=Fireball"
            , test "say house=0 for a blank spell with house rules off, so it isn't a fresh start" <|
                \_ ->
                    UrlState.encode emptyModel
                        |> Expect.equal "?house=0"
            , test "a blank spell with house rules off round-trips onto a model that defaults to on" <|
                \_ ->
                    (UrlState.applyQuery (UrlState.encode emptyModel) { emptyModel | houseRules = True }).houseRules
                        |> Expect.equal False
            , test "a link without house decodes as off" <|
                \_ ->
                    (UrlState.applyQuery "?name=Fireball" { emptyModel | houseRules = True }).houseRules
                        |> Expect.equal False
            , test "an empty query keeps the model's setting" <|
                \_ ->
                    [ "", "?" ]
                        |> List.map (\q -> (UrlState.applyQuery q { emptyModel | houseRules = True }).houseRules)
                        |> Expect.equal [ True, True ]
            , test "a query with only tracking parameters keeps the model's setting" <|
                \_ ->
                    (UrlState.applyQuery "?fbclid=abc123&utm_source=chat" { emptyModel | houseRules = True }).houseRules
                        |> Expect.equal True
            , test "every parameter the encoder writes makes a link that isn't a fresh start" <|
                \_ ->
                    UrlState.encode everyField
                        |> String.dropLeft 1
                        |> String.split "&"
                        |> List.filter (\param -> (UrlState.applyQuery ("?" ++ param) { emptyModel | houseRules = True }).houseRules)
                        |> Expect.equal []
            , test "an old share link decodes as before, with house rules off" <|
                \_ ->
                    UrlState.applyQuery oldLink { emptyModel | houseRules = True }
                        |> Expect.equal
                            { emptyModel
                                | spellName = "Bob's Bolt (big)"
                                , selectedSchool = Just "Evocation"
                                , boltShape = Just "Bolt (5 ft. × 300 ft.)"
                                , seedsPanelOpen = False
                                , seedInstances =
                                    [ { instanceId = 0
                                      , seedId = Energy
                                      , appliedSeedFactors = [ { factorId = "energy_bolt_damage", quantity = 4 } ]
                                      , choices = Dict.fromList [ ( "energy_type", "Fire" ) ]
                                      , baseDCOverride = Nothing
                                      }
                                    , { instanceId = 1
                                      , seedId = Afflict
                                      , appliedSeedFactors = []
                                      , choices = Dict.empty
                                      , baseDCOverride = Just 12
                                      }
                                    ]
                                , nextInstanceId = 2
                                , primarySeedInstanceId = Just 1
                                , appliedFactors = [ { factorId = ChangeToBolt, quantity = 1 }, { factorId = Backlash, quantity = 3 } ]
                            }
            , test "an old share link re-encodes unchanged" <|
                \_ ->
                    UrlState.encode (UrlState.applyQuery oldLink emptyModel)
                        |> Expect.equal oldLink
            ]
        , test "extractQuery strips a pasted URL down to its query" <|
            \_ ->
                UrlState.extractQuery "  https://example.com/app/?name=Fireball&seeds=x  "
                    |> Expect.equal "?name=Fireball&seeds=x"
        ]
