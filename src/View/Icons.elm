module View.Icons exposing (factorsIcon, seedsIcon, shareIcon, summaryIcon)

import Html exposing (Html)
import Svg exposing (circle, line, rect, svg)
import Svg.Attributes as SA


baseAttrs : String -> List (Svg.Attribute msg)
baseAttrs cls =
    [ SA.viewBox "0 0 24 24"
    , SA.fill "none"
    , SA.stroke "currentColor"
    , SA.strokeWidth "1.5"
    , SA.strokeLinecap "round"
    , SA.strokeLinejoin "round"
    , SA.class cls
    ]


seedsIcon : String -> Html msg
seedsIcon cls =
    svg (baseAttrs cls)
        [ Svg.path [ SA.d "M12 21V9" ] []
        , Svg.path [ SA.d "M12 9C12 9 6 9 6 4C11 4 12 9 12 9Z" ] []
        , Svg.path [ SA.d "M12 9C12 9 18 9 18 4C13 4 12 9 12 9Z" ] []
        ]


factorsIcon : String -> Html msg
factorsIcon cls =
    svg (baseAttrs cls)
        [ line [ SA.x1 "4", SA.y1 "6", SA.x2 "20", SA.y2 "6" ] []
        , circle [ SA.cx "9", SA.cy "6", SA.r "2", SA.fill "currentColor", SA.stroke "none" ] []
        , line [ SA.x1 "4", SA.y1 "12", SA.x2 "20", SA.y2 "12" ] []
        , circle [ SA.cx "15", SA.cy "12", SA.r "2", SA.fill "currentColor", SA.stroke "none" ] []
        , line [ SA.x1 "4", SA.y1 "18", SA.x2 "20", SA.y2 "18" ] []
        , circle [ SA.cx "11", SA.cy "18", SA.r "2", SA.fill "currentColor", SA.stroke "none" ] []
        ]


summaryIcon : String -> Html msg
summaryIcon cls =
    svg (baseAttrs cls)
        [ rect [ SA.x "5", SA.y "3", SA.width "14", SA.height "18", SA.rx "2" ] []
        , line [ SA.x1 "8", SA.y1 "8", SA.x2 "16", SA.y2 "8" ] []
        , line [ SA.x1 "8", SA.y1 "12", SA.x2 "16", SA.y2 "12" ] []
        , line [ SA.x1 "8", SA.y1 "16", SA.x2 "13", SA.y2 "16" ] []
        ]


shareIcon : String -> Html msg
shareIcon cls =
    svg (baseAttrs cls)
        [ circle [ SA.cx "18", SA.cy "5", SA.r "2.5", SA.fill "currentColor", SA.stroke "none" ] []
        , circle [ SA.cx "6", SA.cy "12", SA.r "2.5", SA.fill "currentColor", SA.stroke "none" ] []
        , circle [ SA.cx "18", SA.cy "19", SA.r "2.5", SA.fill "currentColor", SA.stroke "none" ] []
        , line [ SA.x1 "8.2", SA.y1 "10.8", SA.x2 "15.8", SA.y2 "6.2" ] []
        , line [ SA.x1 "8.2", SA.y1 "13.2", SA.x2 "15.8", SA.y2 "17.8" ] []
        ]
