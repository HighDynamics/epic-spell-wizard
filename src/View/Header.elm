module View.Header exposing (viewHeader)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Types exposing (..)
import View.Icons exposing (importIcon)


viewHeader : Model -> Html Msg
viewHeader model =
    div [ class "flex items-center justify-between px-6 py-3 bg-gray-900 border-b border-gray-700 shrink-0" ]
        [ h1 [ class "text-2xl font-bold text-arcane-400 tracking-wide" ] [ text "Epic Spell Wizard" ]
        , div [ class "flex items-center gap-2" ]
            ((if model.isStandalone then
                [ button
                    [ class "flex items-center gap-1.5 px-3 py-1.5 rounded border border-arcane-600 text-arcane-400 text-sm hover:bg-arcane-900"
                    , onClick ToggleImportModal
                    ]
                    [ importIcon "w-4 h-4", text "Import Spell" ]
                ]

              else
                []
             )
                ++ [ button
                        [ class "px-3 py-1.5 rounded border border-arcane-600 text-arcane-400 text-sm hover:bg-arcane-900"
                        , onClick ToggleHelpModal
                        ]
                        [ text "How does this work?" ]
                   ]
            )
        ]
