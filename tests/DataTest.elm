module DataTest exposing (suite)

import Expect
import Factors exposing (allFactors, getFactor)
import Seeds exposing (allSeeds, getSeed)
import Set
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Seed and factor data"
        [ test "every seed id is unique" <|
            \_ ->
                allSeeds
                    |> List.map (.id >> Debug.toString)
                    |> Set.fromList
                    |> Set.size
                    |> Expect.equal (List.length allSeeds)
        , test "every factor id is unique" <|
            \_ ->
                allFactors
                    |> List.map (.id >> Debug.toString)
                    |> Set.fromList
                    |> Set.size
                    |> Expect.equal (List.length allFactors)
        , test "getSeed finds every seed" <|
            \_ ->
                allSeeds
                    |> List.map (\s -> getSeed s.id |> Maybe.map .id)
                    |> Expect.equal (List.map (.id >> Just) allSeeds)
        , test "getFactor finds every factor" <|
            \_ ->
                allFactors
                    |> List.map (\f -> getFactor f.id |> Maybe.map .id)
                    |> Expect.equal (List.map (.id >> Just) allFactors)
        , test "seed choices default to one of their options" <|
            \_ ->
                allSeeds
                    |> List.concatMap (\s -> List.map (\c -> ( s.name, c )) s.choices)
                    |> List.filter (\( _, c ) -> not (List.member c.default c.options))
                    |> List.map (\( name, c ) -> name ++ "/" ++ c.id)
                    |> Expect.equal []
        ]
