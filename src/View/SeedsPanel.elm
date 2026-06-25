module View.SeedsPanel exposing (viewSeedsPanel)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Seeds exposing (allSeeds, getSeed)
import Types exposing (..)


viewSeedsPanel : Model -> Html Msg
viewSeedsPanel model =
    if model.seedsPanelOpen then
        div [ class "w-72 shrink-0 flex flex-col bg-gray-900 border-r border-gray-700 overflow-y-auto" ]
            [ -- Panel header with collapse button
              div [ class "flex items-center justify-between px-4 py-3 border-b border-gray-700 sticky top-0 bg-gray-900 z-10" ]
                [ span [ class "text-xs font-bold uppercase tracking-widest text-gray-400" ] [ text "Seeds" ]
                , button
                    [ class "text-gray-500 hover:text-gray-300 text-lg"
                    , onClick ToggleSeedsPanel
                    , title "Collapse panel"
                    ]
                    [ text "◀" ]
                ]
            , -- Seed catalog
              div [ class "p-3 grid grid-cols-1 gap-1" ]
                (List.map (viewSeedCard model.seedInstances) allSeeds)
            , -- Active instances
              if List.isEmpty model.seedInstances then
                div [ class "px-4 py-6 text-gray-600 text-sm text-center" ]
                    [ text "Click a seed to add it to the spell." ]

              else
                div [ class "border-t border-gray-700" ]
                    (List.map viewSeedInstance model.seedInstances)
            ]

    else
        -- Collapsed: narrow tab strip
        div
            [ class "w-8 shrink-0 flex flex-col items-center bg-gray-900 border-r border-gray-700 cursor-pointer hover:bg-gray-800"
            , onClick ToggleSeedsPanel
            , title "Expand seeds panel"
            ]
            [ div [ class "mt-4 text-gray-500 text-xs rotate-90 whitespace-nowrap select-none" ]
                [ text ("SEEDS (" ++ String.fromInt (List.length model.seedInstances) ++ ")") ]
            ]


viewSeedCard : List SeedInstance -> Seed -> Html Msg
viewSeedCard instances seed =
    let
        count =
            List.length (List.filter (\i -> i.seedId == seed.id) instances)

        activeClass =
            if count > 0 then
                "bg-arcane-900 border-arcane-500 text-arcane-400"

            else
                "bg-gray-800 border-gray-700 text-gray-300 hover:border-gray-500"
    in
    button
        [ class ("w-full flex justify-between items-center px-3 py-2 rounded border text-sm " ++ activeClass)
        , onClick (AddSeedInstance seed.id)
        , title seed.description
        ]
        [ span [] [ text seed.name ]
        , span [ class "text-xs text-gray-500 tabular-nums" ]
            [ text (String.fromInt seed.baseDC)
            , if count > 0 then
                span [ class "ml-1 text-arcane-400" ] [ text ("×" ++ String.fromInt count) ]

              else
                text ""
            ]
        ]


viewSeedInstance : SeedInstance -> Html Msg
viewSeedInstance inst =
    case getSeed inst.seedId of
        Nothing ->
            text ""

        Just seed ->
            div [ class "px-3 py-3 border-b border-gray-800" ]
                [ -- Instance header
                  div [ class "flex items-center justify-between mb-2" ]
                    [ span [ class "text-sm font-semibold text-arcane-400" ] [ text seed.name ]
                    , button
                        [ class "text-gray-600 hover:text-red-400 text-xs"
                        , onClick (RemoveSeedInstance inst.instanceId)
                        ]
                        [ text "✕" ]
                    ]
                , -- Original seed description (always visible so the user can read the source text)
                  p [ class "text-xs text-gray-500 italic mb-2 leading-relaxed" ]
                    [ text seed.description ]
                ]
