module View.Header exposing (viewHeader)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Types exposing (..)


viewHeader : Model -> DcBreakdown -> Html Msg
viewHeader model breakdown =
    div [ class "flex items-center justify-between px-6 py-3 bg-gray-900 border-b border-gray-700 shrink-0" ]
        [ input
            [ class "bg-transparent text-2xl font-bold text-gray-100 outline-none placeholder-gray-600 w-96"
            , placeholder "Unnamed Spell"
            , value model.spellName
            , onInput SetSpellName
            ]
            []
        , div [ class "flex items-center gap-3" ]
            [ span [ class "text-gray-400 text-sm uppercase tracking-widest" ] [ text "Spellcraft DC" ]
            , span [ class "text-arcane-400 text-4xl font-bold tabular-nums" ]
                [ text (String.fromInt breakdown.finalDC) ]
            ]
        ]
