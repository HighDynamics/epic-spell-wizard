module View.HouseRulesModal exposing (viewHouseRulesModal)

import HouseRules exposing (Effect(..))
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Types exposing (..)



-- Lists every house-rule change, grouped by whether it adds, removes or
-- replaces an option.


viewHouseRulesModal : Html Msg
viewHouseRulesModal =
    div [ class "fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4" ]
        [ div [ class "bg-gray-900 border border-gray-700 rounded-lg max-w-lg w-full max-h-[85vh] overflow-y-auto p-6 space-y-4" ]
            (div [ class "flex items-center justify-between" ]
                [ h2 [ class "text-lg font-bold text-arcane-400" ] [ text "Sojourner Saga house rules" ]
                , button
                    [ class "text-gray-500 hover:text-gray-300 text-lg"
                    , onClick ToggleHouseRulesModal
                    ]
                    [ text "✕" ]
                ]
                :: viewChanges HouseRules.changes
                ++ [ button
                        [ class "w-full py-2 rounded bg-arcane-500 hover:bg-arcane-400 text-white text-sm font-semibold"
                        , onClick ToggleHouseRulesModal
                        ]
                        [ text "Got it" ]
                   ]
            )
        ]


viewChanges : List HouseRules.Change -> List (Html Msg)
viewChanges changes =
    if List.isEmpty changes then
        [ p [ class "text-sm text-gray-400 leading-relaxed" ]
            [ text "There are no house-rule changes yet, so everything follows the rules as written." ]
        ]

    else
        p [ class "text-sm text-gray-400 leading-relaxed" ]
            [ text "With house rules on, these changes apply:" ]
            :: List.filterMap identity
                [ viewGroup "Added" (List.filter isAdd changes)
                , viewGroup "Removed" (List.filter isRemove changes)
                , viewGroup "Replaced" (List.filter isReplace changes)
                ]


viewGroup : String -> List HouseRules.Change -> Maybe (Html Msg)
viewGroup heading changes =
    if List.isEmpty changes then
        Nothing

    else
        Just
            (div []
                [ h3 [ class "text-sm font-semibold text-gray-200 mb-1" ] [ text heading ]
                , ul [ class "list-disc list-inside text-sm text-gray-400 space-y-0.5" ]
                    (List.map (\change -> li [] [ text change.description ]) changes)
                ]
            )


isAdd : HouseRules.Change -> Bool
isAdd change =
    case change.effect of
        Adds _ ->
            True

        _ ->
            False


isRemove : HouseRules.Change -> Bool
isRemove change =
    case change.effect of
        Removes _ ->
            True

        _ ->
            False


isReplace : HouseRules.Change -> Bool
isReplace change =
    case change.effect of
        Replaces _ _ ->
            True

        _ ->
            False
