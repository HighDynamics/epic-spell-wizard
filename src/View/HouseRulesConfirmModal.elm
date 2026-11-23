module View.HouseRulesConfirmModal exposing (viewHouseRulesConfirmModal)

import HouseRules
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Types exposing (..)



-- Asks before switching house rules would remove options the spell uses.


viewHouseRulesConfirmModal : Model -> Html Msg
viewHouseRulesConfirmModal model =
    let
        switched =
            not model.houseRules

        onOrOff =
            if switched then
                "on"

            else
                "off"

        affected =
            HouseRules.affected HouseRules.changes switched model
    in
    div [ class "fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4" ]
        [ div [ class "bg-gray-900 border border-gray-700 rounded-lg max-w-lg w-full max-h-[85vh] overflow-y-auto p-6 space-y-4" ]
            [ div [ class "flex items-center justify-between" ]
                [ h2 [ class "text-lg font-bold text-arcane-400" ] [ text ("Turn house rules " ++ onOrOff ++ "?") ]
                , button
                    [ class "text-gray-500 hover:text-gray-300 text-lg"
                    , onClick CancelHouseRulesSwitch
                    ]
                    [ text "✕" ]
                ]
            , p [ class "text-sm text-gray-400 leading-relaxed" ]
                [ text
                    ("Turning house rules "
                        ++ onOrOff
                        ++ " removes these from your spell, since they aren't available with house rules "
                        ++ onOrOff
                        ++ " or need something that isn't:"
                    )
                ]
            , ul [ class "list-disc list-inside text-sm text-gray-200 space-y-0.5" ]
                (List.map (\option -> li [] [ text (HouseRules.optionName option) ]) affected)
            , div [ class "flex gap-2" ]
                [ button
                    [ class "flex-1 py-2 rounded border border-arcane-600 text-arcane-400 text-sm hover:bg-arcane-900"
                    , onClick CancelHouseRulesSwitch
                    ]
                    [ text "Cancel" ]
                , button
                    [ class "flex-1 py-2 rounded bg-arcane-500 hover:bg-arcane-400 text-white text-sm font-semibold"
                    , onClick ConfirmHouseRulesSwitch
                    ]
                    [ text "Continue" ]
                ]
            ]
        ]
