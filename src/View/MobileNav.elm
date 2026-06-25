module View.MobileNav exposing (viewMobileNav)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Types exposing (..)
import View.Icons exposing (factorsIcon, seedsIcon, summaryIcon)


viewMobileNav : Model -> Html Msg
viewMobileNav model =
    div [ class "md:hidden fixed bottom-0 inset-x-0 flex border-t border-gray-700 bg-gray-900 z-20" ]
        [ navButton model SeedsTab seedsIcon "Seeds"
        , navButton model FactorsTab factorsIcon "Factors"
        , navButton model SummaryTab summaryIcon "Summary"
        ]


navButton : Model -> MobileTab -> (String -> Html Msg) -> String -> Html Msg
navButton model tab icon label =
    button
        [ class
            ("flex-1 flex flex-col items-center gap-0.5 py-2 text-xs "
                ++ (if model.activeMobileTab == tab then
                        "text-arcane-400"

                    else
                        "text-gray-500"
                   )
            )
        , onClick (SetMobileTab tab)
        ]
        [ icon "w-5 h-5"
        , span [] [ text label ]
        ]
