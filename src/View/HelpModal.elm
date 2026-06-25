module View.HelpModal exposing (viewHelpModal)

import Html exposing (..)
import Html.Attributes exposing (class, href, rel, target)
import Html.Events exposing (onClick)
import Types exposing (..)


viewHelpModal : Html Msg
viewHelpModal =
    div [ class "fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4" ]
        [ div [ class "bg-gray-900 border border-gray-700 rounded-lg max-w-lg w-full max-h-[85vh] overflow-y-auto p-6 space-y-4" ]
            [ div [ class "flex items-center justify-between" ]
                [ h2 [ class "text-lg font-bold text-arcane-400" ] [ text "How does this work?" ]
                , button
                    [ class "text-gray-500 hover:text-gray-300 text-lg"
                    , onClick ToggleHelpModal
                    ]
                    [ text "✕" ]
                ]
            , viewSuggestedReading
            , viewSection "The basic flow"
                ("Add seeds from the Seeds panel, then tune their factors and choices "
                    ++ "(and any global augmenting or mitigating factors) in the Factors panel. "
                    ++ "The Summary panel keeps a running DC breakdown, development costs, and "
                    ++ "stat block as you go."
                )
            , viewSection "The link is your save"
                ("The address bar updates live as you work — it always reflects the exact "
                    ++ "spell you're building. Copying the URL, using the Share button next to "
                    ++ "the spell name, or just bookmarking the page at any point is how you "
                    ++ "\"save\" — reopening that link rebuilds the spell exactly as you left it. "
                    ++ "The \"Epic Spell Wizard Link\" at the top of a copied spell summary is "
                    ++ "the same link."
                )
            , viewSection "Nothing here is prohibited"
                ("Epic spell development is meant to be flexible, so this tool doesn't stop "
                    ++ "you from combining factors or mitigations that don't really make sense "
                    ++ "together. If you and your DM have worked out some unusual combination, "
                    ++ "go for it — it's on you to make sure the choices you select are "
                    ++ "actually applicable to what you're building."
                )
            , viewSection "This isn't the final word"
                ("This tool is a calculator and organizer, not a rules authority. Epic spell "
                    ++ "development is a collaborative process — any spell you develop here "
                    ++ "still needs your Dungeon Master's approval."
                )
            , button
                [ class "w-full py-2 rounded bg-arcane-500 hover:bg-arcane-400 text-white text-sm font-semibold"
                , onClick ToggleHelpModal
                ]
                [ text "Got it" ]
            ]
        ]


viewSuggestedReading : Html Msg
viewSuggestedReading =
    div []
        [ h3 [ class "text-sm font-semibold text-gray-200 mb-1" ] [ text "Suggested reading" ]
        , p [ class "text-sm text-gray-400 leading-relaxed mb-1" ]
            [ text "This tool assumes you already know how epic spells work. If you're new to the system, read these first:" ]
        , ul [ class "list-disc list-inside text-sm space-y-0.5" ]
            [ li []
                [ a
                    [ href "https://www.d20srd.org/srd/epic/spellsIntro.htm"
                    , target "_blank"
                    , rel "noopener noreferrer"
                    , class "text-arcane-400 hover:text-arcane-500 underline"
                    ]
                    [ text "Epic Spells: Introduction" ]
                ]
            , li []
                [ a
                    [ href "https://www.d20srd.org/srd/epic/developingEpicSpells.htm"
                    , target "_blank"
                    , rel "noopener noreferrer"
                    , class "text-arcane-400 hover:text-arcane-500 underline"
                    ]
                    [ text "Developing Epic Spells" ]
                ]
            ]
        ]


viewSection : String -> String -> Html Msg
viewSection heading body =
    div []
        [ h3 [ class "text-sm font-semibold text-gray-200 mb-1" ] [ text heading ]
        , p [ class "text-sm text-gray-400 leading-relaxed" ] [ text body ]
        ]
