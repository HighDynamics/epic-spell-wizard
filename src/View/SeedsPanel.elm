module View.SeedsPanel exposing (viewSeedsPanel)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Seeds exposing (allSeeds)
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
            , div [ class "px-4 py-3 text-gray-500 text-xs text-center border-b border-gray-800" ]
                [ text "Click/Tap to add a seed to your spell" ]
            , -- Seed catalog
              div [ class "p-3 grid grid-cols-1 gap-1" ]
                (List.map (viewSeedCard model.seedInstances) allSeeds)
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
