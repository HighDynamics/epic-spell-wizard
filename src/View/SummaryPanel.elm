module View.SummaryPanel exposing (viewSummaryPanel)

import Calc exposing (StatBlockData)
import Export
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Types exposing (..)


viewSummaryPanel : Model -> DcBreakdown -> DevCosts -> StatBlockData -> Html Msg
viewSummaryPanel model breakdown costs sb =
    if model.summaryPanelOpen then
        div [ class "w-72 shrink-0 flex flex-col bg-gray-900 overflow-y-auto" ]
            [ -- Panel header
              div [ class "flex items-center justify-between px-4 py-3 border-b border-gray-700 sticky top-0 bg-gray-900 z-10" ]
                [ span [ class "text-xs font-bold uppercase tracking-widest text-gray-400" ] [ text "Summary" ]
                , button
                    [ class "text-gray-500 hover:text-gray-300 text-lg"
                    , onClick ToggleSummaryPanel
                    , title "Collapse panel"
                    ]
                    [ text "▶" ]
                ]
            , div [ class "p-4 space-y-5" ]
                [ viewDcBreakdown breakdown
                , viewDevCosts costs
                , viewStatBlock sb
                , viewDescriptionBox model
                , viewExportButton model
                ]
            ]

    else
        div
            [ class "w-8 shrink-0 flex flex-col items-center bg-gray-900 cursor-pointer hover:bg-gray-800"
            , onClick ToggleSummaryPanel
            , title "Expand summary panel"
            ]
            [ div [ class "mt-4 text-gray-500 text-xs rotate-90 whitespace-nowrap select-none" ]
                [ text "SUMMARY" ]
            ]


viewDcBreakdown : DcBreakdown -> Html Msg
viewDcBreakdown bd =
    div []
        [ div [ class "text-xs font-bold uppercase tracking-widest text-gray-400 mb-2" ] [ text "DC Breakdown" ]
        , div [ class "space-y-1 text-sm" ]
            [ viewBreakdownRow "Seeds" (showSign bd.seedsTotal) "text-gray-300"
            , viewBreakdownRow "Seed factors" (showSign bd.seedFactorsTotal) "text-gray-300"
            , viewBreakdownRow "Augmenting" (showSign bd.augmentingTotal) "text-gray-300"
            , if bd.permanentMultiplier > 1 then
                viewBreakdownRow "× Permanent" ("×" ++ String.fromInt bd.permanentMultiplier) "text-yellow-400"
              else
                text ""
            , if bd.stoneTabletMultiplier > 1 then
                viewBreakdownRow "× Stone Tablet" ("×" ++ String.fromInt bd.stoneTabletMultiplier) "text-yellow-400"
              else
                text ""
            , viewBreakdownRow "Mitigating" (showSign bd.mitigatingTotal) "text-green-400"
            , div [ class "border-t border-gray-700 pt-1 mt-1 flex justify-between" ]
                [ span [ class "text-gray-400 text-xs uppercase" ] [ text "Final DC" ]
                , span [ class "text-arcane-400 text-lg font-bold tabular-nums" ]
                    [ text (String.fromInt bd.finalDC) ]
                ]
            ]
        ]


viewBreakdownRow : String -> String -> String -> Html Msg
viewBreakdownRow label val colorClass =
    div [ class "flex justify-between" ]
        [ span [ class "text-gray-500 text-xs" ] [ text label ]
        , span [ class ("text-xs tabular-nums " ++ colorClass) ] [ text val ]
        ]


showSign : Int -> String
showSign n =
    if n >= 0 then
        "+" ++ String.fromInt n
    else
        String.fromInt n


viewDevCosts : DevCosts -> Html Msg
viewDevCosts costs =
    div []
        [ div [ class "text-xs font-bold uppercase tracking-widest text-gray-400 mb-2" ] [ text "Development" ]
        , div [ class "space-y-1" ]
            [ viewCostRow "Gold" (formatNumber costs.goldCost ++ " gp")
            , viewCostRow "Time" (String.fromInt costs.timeDays ++ " days")
            , viewCostRow "XP" (formatNumber costs.xpCost ++ " XP")
            ]
        ]


viewCostRow : String -> String -> Html Msg
viewCostRow label val =
    div [ class "flex justify-between text-sm" ]
        [ span [ class "text-gray-500 text-xs" ] [ text label ]
        , span [ class "text-gray-200 text-xs tabular-nums" ] [ text val ]
        ]


formatNumber : Int -> String
formatNumber n =
    -- Insert commas: 423000 → "423,000"
    let
        str = String.fromInt n
        len = String.length str
    in
    if len <= 3 then
        str
    else
        formatNumber (n // 1000) ++ "," ++ String.padLeft 3 '0' (String.fromInt (modBy 1000 n))


viewStatBlock : StatBlockData -> Html Msg
viewStatBlock sb =
    let
        row label val =
            div [ class "flex gap-2 text-xs" ]
                [ span [ class "text-gray-500 w-24 shrink-0" ] [ text label ]
                , span [ class "text-gray-200" ] [ text val ]
                ]

        descriptorStr =
            if List.isEmpty sb.descriptors then
                ""
            else
                " [" ++ String.join ", " sb.descriptors ++ "]"
    in
    div []
        [ div [ class "text-xs font-bold uppercase tracking-widest text-gray-400 mb-2" ] [ text "Stat Block" ]
        , div [ class "space-y-1" ]
            [ row "School" (sb.school ++ descriptorStr)
            , row "Components" (String.join ", " sb.components)
            , row "Casting Time" sb.castingTime
            , row "Range" sb.range
            , row "Target/Area" sb.targetAreaEffect
            , row "Duration" sb.duration
            , row "Saving Throw" sb.savingThrow
            , row "Spell Resistance" sb.spellResistance
            ]
        ]


viewDescriptionBox : Model -> Html Msg
viewDescriptionBox model =
    let
        description =
            Export.generateDescription model.seedInstances model.appliedFactors
    in
    div []
        [ div [ class "mb-1" ]
            [ span [ class "text-xs font-bold uppercase tracking-widest text-gray-400" ] [ text "Description" ] ]
        , div
            [ class "w-full text-gray-200 text-xs py-2 whitespace-pre-wrap leading-relaxed" ]
            [ text description ]
        ]


viewExportButton : Model -> Html Msg
viewExportButton model =
    div []
        [ button
            [ class "w-full py-2 rounded bg-arcane-500 hover:bg-arcane-400 text-white text-sm font-semibold"
            , onClick ExportMarkdown
            ]
            [ text "Copy Spell Details" ]
        , case model.copySuccess of
            Just True ->
                div [ class "text-green-400 text-xs text-center mt-1" ] [ text "Copied to clipboard!" ]
            Just False ->
                div [ class "text-red-400 text-xs text-center mt-1" ] [ text "Copy failed — check browser permissions." ]
            Nothing ->
                text ""
        ]
