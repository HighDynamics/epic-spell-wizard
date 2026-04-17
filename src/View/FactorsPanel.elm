module View.FactorsPanel exposing (viewFactorsPanel)

import Dict
import Factors exposing (allFactors)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Seeds exposing (getSeed)
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
viewSeedInstanceFactors _ inst =
    case getSeed inst.seedId of
        Nothing ->
            text ""

        Just seed ->
            let
                activeModeFactors =
                    inst.selectedMode
                        |> Maybe.andThen
                            (\mId ->
                                List.head (List.filter (\m -> m.id == mId) seed.modes)
                                    |> Maybe.map .factors
                            )
                        |> Maybe.withDefault []

                availableFactors =
                    seed.universalFactors ++ activeModeFactors

                modeRow =
                    if List.isEmpty seed.modes then
                        []

                    else
                        [ div [ class "mb-2" ]
                            [ label [ class "text-xs text-gray-500 mb-1 block" ] [ text "Mode" ]
                            , select
                                [ class "w-full bg-gray-800 text-gray-200 text-xs rounded px-2 py-1 border border-gray-700"
                                , onInput (SelectMode inst.instanceId)
                                ]
                                (option [ value "" ] [ text "— select mode —" ]
                                    :: List.map
                                        (\m ->
                                            option
                                                [ value m.id
                                                , selected (inst.selectedMode == Just m.id)
                                                ]
                                                [ text m.name ]
                                        )
                                        seed.modes
                                )
                            ]
                        ]

                choiceRows =
                    List.map (viewChoiceDropdown inst) seed.choices

                factorRows =
                    if List.isEmpty availableFactors then
                        [ p [ class "text-gray-500 text-xs italic mt-1" ] [ text "No seed-specific factors" ] ]

                    else
                        List.map (viewSeedFactor inst) availableFactors
            in
            div [ class "border-b border-gray-800" ]
                [ div [ class "px-4 py-2 bg-gray-900 text-xs text-arcane-400 font-semibold uppercase tracking-wider" ]
                    [ text ("── " ++ seed.name ++ " ──") ]
                , div [ class "px-4 py-2" ]
                    (modeRow ++ choiceRows ++ factorRows)
                ]


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
                ""

            else
                " opacity-40"

        dcLabel =
            if sf.dcModifier == 0 then
                "(special)"

            else if sf.dcModifier > 0 then
                "+" ++ String.fromInt (sf.dcModifier * Basics.max 1 currentQty) ++ " DC"

            else
                String.fromInt (sf.dcModifier * Basics.max 1 currentQty) ++ " DC"
    in
    div [ class ("flex items-center justify-between py-1 gap-2 text-sm" ++ dimClass) ]
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
            (List.map
                (\f ->
                    let
                        maybeApplied =
                            List.head (List.filter (\af -> af.factorId == f.id) model.appliedFactors)
                    in
                    viewGlobalFactorRow f maybeApplied
                )
                categoryFactors
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
                ""

            else
                " opacity-40"

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
    div [ class ("flex items-center justify-between py-1 gap-2 text-sm h-10" ++ dimClass) ]
        [ div [ class "flex-1 min-w-0" ]
            [ div [ class "text-gray-200 text-xs truncate" ] [ text factor.name ]
            , div [ class "text-gray-500 text-xs" ] [ text factor.shortDesc ]
            ]
        , div [ class "flex items-center gap-1 shrink-0" ]
            [ span [ class "text-gray-500 text-xs w-16 text-right" ] [ text dcDisplay ]
            , controls
            ]
        ]
