module CalcTest exposing (suite)

import Calc
import Dict
import Expect
import Seeds exposing (allSeeds)
import Test exposing (Test, describe, test)
import Types exposing (..)


instanceOf : Int -> Seed -> SeedInstance
instanceOf index seed =
    { instanceId = index
    , seedId = seed.id
    , appliedSeedFactors = []
    , choices = Dict.empty
    , baseDCOverride = Nothing
    }


suite : Test
suite =
    describe "Calc"
        [ describe "devCosts"
            [ test "costs 9000 gp per DC" <|
                \_ -> (Calc.devCosts 100).goldCost |> Expect.equal 900000
            , test "rounds time up to whole days at 50,000 gp/day" <|
                \_ -> (Calc.devCosts 6).timeDays |> Expect.equal 2
            , test "XP cost is gold / 25" <|
                \_ -> (Calc.devCosts 100).xpCost |> Expect.equal 36000
            ]
        , describe "calculateBreakdown"
            [ test "the final DC never drops below 1" <|
                \_ -> (Calc.calculateBreakdown [] []).finalDC |> Expect.equal 1
            , test "Permanent multiplies the running total by 5" <|
                \_ ->
                    let
                        seeds =
                            List.indexedMap instanceOf (List.take 1 allSeeds)

                        plain =
                            (Calc.calculateBreakdown seeds []).finalDC

                        permanent =
                            (Calc.calculateBreakdown seeds [ { factorId = PermanentDuration, quantity = 1 } ]).finalDC
                    in
                    permanent |> Expect.equal (plain * 5)
            ]
        , describe "statBlock"
            [ test "fills in a casting time for every seed alone" <|
                \_ ->
                    allSeeds
                        |> List.indexedMap instanceOf
                        |> List.filter
                            (\inst ->
                                (Calc.statBlock [ inst ] [] 0 (Just inst.instanceId) Nothing Nothing Nothing Nothing Nothing).castingTime
                                    |> String.isEmpty
                            )
                        |> List.map .seedId
                        |> Expect.equal []
            ]
        ]
