module View.SeedsPanel exposing (viewSeedsPanel)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Seeds exposing (allSeeds)
import Types exposing (..)
import View.Icons exposing (seedsIcon)


mobileVis : Model -> String
mobileVis model =
    if model.activeMobileTab == SeedsTab then
        "flex"

    else
        "hidden"


viewSeedsPanel : Model -> Html Msg
viewSeedsPanel model =
    if model.seedsPanelOpen then
        div [ class (mobileVis model ++ " flex-col w-full md:flex md:w-72 shrink-0 bg-gray-900 border-r border-gray-700 overflow-y-auto") ]
            [ -- Panel header with collapse button
              div [ class "flex items-center justify-between px-4 py-3 border-b border-gray-700 sticky top-0 bg-gray-900 z-10" ]
                [ span [ class "flex items-center gap-1.5 text-xs font-bold uppercase tracking-widest text-gray-400" ]
                    [ seedsIcon "w-3.5 h-3.5", text "Seeds" ]
                , button
                    [ class "hidden md:inline-block text-gray-500 hover:text-gray-300 text-lg"
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
            [ class (mobileVis model ++ " flex-col items-center gap-2 w-full md:flex md:w-8 shrink-0 bg-gray-900 border-r border-gray-700 cursor-pointer hover:bg-gray-800 pt-4")
            , onClick ToggleSeedsPanel
            , title "Expand seeds panel"
            ]
            [ seedsIcon "w-4 h-4 text-gray-500"
            , div
                [ style "writing-mode" "vertical-rl"
                , class "text-gray-500 text-xs whitespace-nowrap select-none"
                ]
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
