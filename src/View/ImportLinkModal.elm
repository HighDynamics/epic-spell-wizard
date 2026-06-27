module View.ImportLinkModal exposing (viewImportLinkModal)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, rows, value)
import Html.Events exposing (onClick, onInput)
import Types exposing (..)


viewImportLinkModal : Model -> Html Msg
viewImportLinkModal model =
    div [ class "fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4" ]
        [ div [ class "bg-gray-900 border border-gray-700 rounded-lg max-w-lg w-full p-6 space-y-4" ]
            [ div [ class "flex items-center justify-between" ]
                [ h2 [ class "text-lg font-bold text-arcane-400" ] [ text "Import a spell link" ]
                , button
                    [ class "text-gray-500 hover:text-gray-300 text-lg"
                    , onClick ToggleImportModal
                    ]
                    [ text "✕" ]
                ]
            , p [ class "text-sm text-gray-400 leading-relaxed" ]
                [ text "Paste a shared Epic Spell Wizard link (or just its query string) below to load that spell here, replacing whatever you're currently building." ]
            , textarea
                [ class "w-full bg-gray-800 border border-gray-600 rounded px-3 py-2 text-base md:text-sm text-gray-100 outline-none focus:border-arcane-400"
                , rows 4
                , placeholder "https://.../epic-spell-wizard/?name=..."
                , value model.importInput
                , onInput SetImportInput
                ]
                []
            , case model.importError of
                Just message ->
                    p [ class "text-red-400 text-xs" ] [ text message ]

                Nothing ->
                    text ""
            , button
                [ class "w-full py-2 rounded bg-arcane-500 hover:bg-arcane-400 text-white text-sm font-semibold"
                , onClick LoadImportedLink
                ]
                [ text "Load" ]
            ]
        ]
