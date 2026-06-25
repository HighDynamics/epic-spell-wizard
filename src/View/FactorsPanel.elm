module View.FactorsPanel exposing (viewFactorsPanel)

import Calc exposing (targetToAreaShapes)
import Dict
import Factors exposing (allFactors)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Seeds exposing (getSeed, isSpecialSeedFactor)
import Types exposing (..)


viewFactorsPanel : Model -> DcBreakdown -> Html Msg
viewFactorsPanel model _ =
    if model.factorsPanelOpen then
        div [ class "flex-1 flex flex-col bg-gray-950 border-r border-gray-700 overflow-y-auto min-w-0" ]
            [ -- Panel header
              div [ class "flex items-center justify-between px-4 py-3 border-b border-gray-700 sticky top-0 bg-gray-950 z-10" ]
                [ span [ class "text-xs font-bold uppercase tracking-widest text-gray-400" ] [ text "Factors" ]
                , button
                    [ class "text-gray-500 hover:text-gray-300 text-lg"
                    , onClick ToggleFactorsPanel
                    , title "Collapse panel"
                    ]
                    [ text "◀" ]
                ]
            , -- Per-instance seed factor sub-panels
              div [] (List.map (viewSeedInstanceFactors model) model.seedInstances)
            , -- Global augmenting factors
              viewGlobalFactorSection model "Augmenting" Augmenting
            , -- Global mitigating factors
              viewGlobalFactorSection model "Mitigating" Mitigating
            ]

    else
        let
            totalFactors =
                List.length model.appliedFactors
                    + List.sum (List.map (\i -> List.length i.appliedSeedFactors) model.seedInstances)
        in
        div
            [ class "w-8 shrink-0 flex flex-col items-center bg-gray-950 border-r border-gray-700 cursor-pointer hover:bg-gray-900"
            , onClick ToggleFactorsPanel
            , title "Expand factors panel"
            ]
            [ div [ class "mt-4 text-gray-500 text-xs rotate-90 whitespace-nowrap select-none" ]
                [ text ("FACTORS (" ++ String.fromInt totalFactors ++ ")") ]
            ]



-- ─── Per-seed factor sub-panel ────────────────────────────────────────────────


viewSeedInstanceFactors : Model -> SeedInstance -> Html Msg
viewSeedInstanceFactors model inst =
    case getSeed inst.seedId of
        Nothing ->
            text ""

        Just seed ->
            let
                choiceRows =
                    List.map (viewChoiceDropdown inst) seed.choices

                universalFactorRows =
                    List.map (viewSeedFactor inst) seed.universalFactors

                modeFactorSections =
                    seed.modes
                        |> List.filter (\m -> not (List.isEmpty m.factors))
                        |> List.concatMap
                            (\m ->
                                div [ class "text-xs text-indigo-500 font-semibold uppercase tracking-wider mt-2 mb-1 pt-2 border-t border-gray-800" ]
                                    [ text m.name ]
                                    :: List.map (viewSeedFactor inst) m.factors
                            )

                factorRows =
                    if List.isEmpty universalFactorRows && List.isEmpty modeFactorSections then
                        [ p [ class "text-gray-500 text-xs italic mt-1" ] [ text "No seed-specific factors" ] ]

                    else
                        universalFactorRows ++ modeFactorSections

                currentDC =
                    Maybe.withDefault seed.baseDC inst.baseDCOverride

                baseDCRow =
                    div [ class "flex items-center justify-between py-1 gap-2 text-sm h-10" ]
                        [ div [ class "flex-1 min-w-0" ]
                            [ div [ class "text-gray-200 text-xs" ] [ text "Base DC" ]
                            , div [ class "text-gray-500 text-xs" ] [ text ("default: " ++ String.fromInt seed.baseDC) ]
                            ]
                        , div [ class "flex items-center gap-1 shrink-0" ]
                            [ button
                                [ class "w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center"
                                , onClick (SetSeedBaseDCOverride inst.instanceId (String.fromInt (currentDC - 1)))
                                ]
                                [ text "−" ]
                            , input
                                [ type_ "text"
                                , attribute "inputmode" "numeric"
                                , value (String.fromInt currentDC)
                                , onInput (SetSeedBaseDCOverride inst.instanceId)
                                , class "w-10 bg-gray-800 border border-gray-600 rounded px-2 py-0.5 text-xs text-gray-100 tabular-nums text-center focus:outline-none focus:border-arcane-400"
                                ]
                                []
                            , button
                                [ class "w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center"
                                , onClick (SetSeedBaseDCOverride inst.instanceId (String.fromInt (currentDC + 1)))
                                ]
                                [ text "+" ]
                            ]
                        ]
            in
            div [ class "border-b border-gray-800" ]
                [ div [ class "flex items-center justify-between px-4 py-2 bg-gray-900" ]
                    [ span [ class "text-xs text-arcane-400 font-semibold uppercase tracking-wider" ]
                        [ text ("── " ++ seed.name ++ " ──") ]
                    , div [ class "flex items-center gap-2" ]
                        [ if List.length model.seedInstances > 1 then
                            if model.primarySeedInstanceId == Just inst.instanceId then
                                span [ class "text-xs text-arcane-400 font-semibold px-1.5 py-0.5 rounded border border-arcane-700 bg-arcane-950" ]
                                    [ text "Primary" ]

                            else
                                button
                                    [ class "text-xs text-gray-600 hover:text-gray-300 px-1.5 py-0.5 rounded border border-gray-800 hover:border-gray-600"
                                    , onClick (SetPrimarySeed inst.instanceId)
                                    ]
                                    [ text "Make primary" ]

                          else
                            text ""
                        , button
                            [ class "text-gray-600 hover:text-red-400 text-xs"
                            , onClick (RemoveSeedInstance inst.instanceId)
                            ]
                            [ text "✕" ]
                        ]
                    ]
                , div [ class "px-4 py-2" ]
                    (viewSeedDescriptionQuote seed :: baseDCRow :: choiceRows ++ factorRows)
                ]


viewSeedDescriptionQuote : Seed -> Html Msg
viewSeedDescriptionQuote seed =
    blockquote
        [ class "border-l-2 border-gray-700 pl-3 mb-3 text-gray-400 text-xs italic leading-relaxed" ]
        [ text seed.description ]


viewChoiceDropdown : SeedInstance -> SeedChoice -> Html Msg
viewChoiceDropdown inst choice =
    let
        current =
            Dict.get choice.id inst.choices |> Maybe.withDefault choice.default
    in
    div [ class "mb-2" ]
        [ label [ class "text-xs text-gray-500 mb-1 block" ] [ text choice.label ]
        , select
            [ class "w-full bg-gray-800 text-gray-200 text-xs rounded px-2 py-1 border border-gray-700"
            , onInput (SetChoice inst.instanceId choice.id)
            ]
            (List.map
                (\opt ->
                    option [ value opt, selected (current == opt) ] [ text opt ]
                )
                choice.options
            )
        ]


viewSeedFactor : SeedInstance -> SeedFactor -> Html Msg
viewSeedFactor inst sf =
    let
        currentQty =
            inst.appliedSeedFactors
                |> List.filter (\asf -> asf.factorId == sf.id)
                |> List.head
                |> Maybe.map .quantity
                |> Maybe.withDefault 0

        isActive =
            currentQty > 0

        dimClass =
            if isActive then
                " bg-arcane-800/50 rounded"

            else
                " opacity-60"

        dcLabel =
            if isSpecialSeedFactor sf.id then
                "(special)"

            else if sf.dcModifier > 0 then
                "+" ++ String.fromInt (sf.dcModifier * Basics.max 1 currentQty) ++ " DC"

            else
                String.fromInt (sf.dcModifier * Basics.max 1 currentQty) ++ " DC"
    in
    div [ class ("flex items-center justify-between py-1 px-2 -mx-2 gap-2 text-sm" ++ dimClass) ]
        [ div [ class "flex-1 min-w-0" ]
            [ div [ class "text-gray-200 text-xs truncate" ] [ text sf.name ]
            , if String.isEmpty sf.description then
                text ""

              else
                div [ class "text-gray-500 text-xs truncate" ] [ text sf.description ]
            ]
        , div [ class "flex items-center gap-1 shrink-0" ]
            [ span [ class "text-gray-500 text-xs w-16 text-right" ] [ text dcLabel ]
            , case sf.kind of
                SeedToggle ->
                    button
                        [ class
                            (if currentQty > 0 then
                                "px-2 py-0.5 rounded text-xs bg-arcane-500 text-white"

                             else
                                "px-2 py-0.5 rounded text-xs bg-gray-700 text-gray-300 hover:bg-gray-600"
                            )
                        , onClick
                            (SetSeedFactor inst.instanceId
                                sf.id
                                (if currentQty > 0 then
                                    0

                                 else
                                    1
                                )
                            )
                        ]
                        [ text
                            (if currentQty > 0 then
                                "On"

                             else
                                "Off"
                            )
                        ]

                SeedStackable ->
                    div [ class "flex items-center gap-1" ]
                        [ button
                            [ class "w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center"
                            , onClick (SetSeedFactor inst.instanceId sf.id (Basics.max 0 (currentQty - 1)))
                            ]
                            [ text "−" ]
                        , span [ class "text-xs text-gray-300 w-4 text-center tabular-nums" ]
                            [ text (String.fromInt currentQty) ]
                        , button
                            [ class "w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center"
                            , onClick
                                (SetSeedFactor inst.instanceId
                                    sf.id
                                    (case sf.maxQuantity of
                                        Nothing ->
                                            currentQty + 1

                                        Just mx ->
                                            Basics.min mx (currentQty + 1)
                                    )
                                )
                            ]
                            [ text "+" ]
                        ]
            ]
        ]



-- ─── Global factor section (augmenting or mitigating) ─────────────────────────


viewGlobalFactorSection : Model -> String -> FactorCategory -> Html Msg
viewGlobalFactorSection model label category =
    let
        categoryFactors =
            List.filter (\f -> f.category == category) allFactors
    in
    div [ class "border-b border-gray-800" ]
        [ div [ class "px-4 py-2 bg-gray-900 text-xs text-gray-400 font-semibold uppercase tracking-wider" ]
            [ text ("── Global " ++ label ++ " ──") ]
        , div [ class "px-4 py-2" ]
            (categoryFactors
                |> List.foldl
                    (\f ( lastSection, rows ) ->
                        let
                            maybeApplied =
                                List.head (List.filter (\af -> af.factorId == f.id) model.appliedFactors)

                            isActive =
                                maybeApplied /= Nothing

                            extraRows =
                                if f.id == TargetToArea && isActive then
                                    [ viewAreaShapeDropdown model.targetToAreaShape SetTargetToAreaShape ]

                                else if f.id == PersonalToArea && isActive then
                                    [ viewAreaShapeDropdown model.personalToAreaShape SetPersonalToAreaShape ]

                                else
                                    []

                            headerRow =
                                if Just f.section /= lastSection then
                                    [ viewFactorSectionHeader f.section ]

                                else
                                    []
                        in
                        ( Just f.section, rows ++ headerRow ++ (viewGlobalFactorRow f maybeApplied :: extraRows) )
                    )
                    ( Nothing, [] )
                |> Tuple.second
            )
        ]


viewFactorSectionHeader : String -> Html Msg
viewFactorSectionHeader sectionName =
    div [ class "text-xs text-indigo-500 font-semibold uppercase tracking-wider mt-2 mb-1 pt-2 border-t border-gray-800 first:mt-0 first:border-t-0" ]
        [ text sectionName ]


viewAreaShapeDropdown : Maybe String -> (String -> Msg) -> Html Msg
viewAreaShapeDropdown maybeShape toMsg =
    div [ class "flex items-center justify-between py-1 gap-2 pl-4" ]
        [ label [ class "text-xs text-gray-400 shrink-0" ] [ text "Area shape" ]
        , select
            [ class "flex-1 bg-gray-800 text-gray-200 text-xs rounded px-2 py-1 border border-gray-700"
            , onInput toMsg
            ]
            (option [ value "", Html.Attributes.selected (maybeShape == Nothing) ] [ text "— select —" ]
                :: List.map
                    (\shape ->
                        option
                            [ value shape
                            , Html.Attributes.selected (maybeShape == Just shape)
                            ]
                            [ text shape ]
                    )
                    targetToAreaShapes
            )
        ]


viewGlobalFactorRow : Factor -> Maybe AppliedFactor -> Html Msg
viewGlobalFactorRow factor maybeApplied =
    let
        isActive =
            maybeApplied /= Nothing

        qty =
            maybeApplied |> Maybe.map .quantity |> Maybe.withDefault 0

        dimClass =
            if isActive then
                " bg-arcane-800/50 rounded"

            else
                " opacity-60"

        dcDisplay =
            case factor.kind of
                Toggle ->
                    if factor.dcModifier > 0 then
                        "+" ++ String.fromInt factor.dcModifier ++ " DC"

                    else
                        String.fromInt factor.dcModifier ++ " DC"

                Stackable ->
                    if not isActive then
                        (if factor.dcModifier > 0 then
                            "+"

                         else
                            ""
                        )
                            ++ String.fromInt factor.dcModifier
                            ++ " DC ea."

                    else
                        let
                            total =
                                factor.dcModifier * qty
                        in
                        (if total > 0 then
                            "+"

                         else
                            ""
                        )
                            ++ String.fromInt total
                            ++ " DC"

                DcMultiplier ->
                    "×" ++ String.fromInt factor.multiplierValue

        controls =
            case factor.kind of
                Stackable ->
                    div [ class "flex items-center gap-1" ]
                        [ button
                            [ class "w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center disabled:opacity-30 disabled:cursor-not-allowed"
                            , onClick (SetGlobalFactorQty factor.id (Basics.max 0 (qty - 1)))
                            , disabled (qty == 0)
                            ]
                            [ text "−" ]
                        , span [ class "text-xs text-gray-300 w-4 text-center tabular-nums" ]
                            [ text (String.fromInt qty) ]
                        , button
                            [ class "w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center"
                            , onClick
                                (if isActive then
                                    SetGlobalFactorQty factor.id (qty + 1)

                                 else
                                    AddGlobalFactor factor.id
                                )
                            ]
                            [ text "+" ]
                        ]

                Toggle ->
                    input
                        [ type_ "checkbox"
                        , checked isActive
                        , onClick
                            (if isActive then
                                RemoveGlobalFactor factor.id

                             else
                                AddGlobalFactor factor.id
                            )
                        , class "w-4 h-4 accent-arcane-500 cursor-pointer"
                        ]
                        []

                DcMultiplier ->
                    input
                        [ type_ "checkbox"
                        , checked isActive
                        , onClick
                            (if isActive then
                                RemoveGlobalFactor factor.id

                             else
                                AddGlobalFactor factor.id
                            )
                        , class "w-4 h-4 accent-arcane-500 cursor-pointer"
                        ]
                        []
    in
    div [ class ("flex items-center justify-between py-1 px-2 -mx-2 gap-2 text-sm h-10" ++ dimClass) ]
        [ div [ class "flex-1 min-w-0" ]
            [ div [ class "text-gray-200 text-xs truncate" ] [ text factor.name ]
            , div [ class "text-gray-500 text-xs" ] [ text factor.shortDesc ]
            ]
        , div [ class "flex items-center gap-1 shrink-0" ]
            [ span [ class "text-gray-500 text-xs w-16 text-right" ] [ text dcDisplay ]
            , controls
            ]
        ]
