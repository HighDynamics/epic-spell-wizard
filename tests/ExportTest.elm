module ExportTest exposing (suite)

import Expect
import Export
import Test exposing (Test, describe, test)


plainText : Bool -> String
plainText houseRules =
    Export.generatePlainText "https://example.com/?name=Fireball" "Fireball" houseRules [] [] 0 Nothing Nothing Nothing Nothing


markdown : Bool -> String
markdown houseRules =
    Export.generateMarkdown "https://example.com/?name=Fireball" "Fireball" houseRules [] [] 0 Nothing Nothing Nothing Nothing


suite : Test
suite =
    describe "Export"
        [ test "plain text says which rules apply, right below the title" <|
            \_ ->
                List.map (plainText >> String.lines >> List.take 2) [ True, False ]
                    |> Expect.equal [ [ "Fireball", "House rules: on" ], [ "Fireball", "Rules as written" ] ]
        , test "markdown says which rules apply, right below the title" <|
            \_ ->
                List.map (markdown >> String.lines >> List.take 3) [ True, False ]
                    |> Expect.equal [ [ "# Fireball", "", "_House rules: on_" ], [ "# Fireball", "", "_Rules as written_" ] ]
        ]
