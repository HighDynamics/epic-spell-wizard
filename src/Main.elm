port module Main exposing (main)

import Browser
import Calc exposing (StatBlockData, calculateBreakdown, devCosts, statBlock)
import Export
import Dict exposing (Dict)
import Factors exposing (allFactors, getFactor)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Seeds exposing (allSeeds, getSeed)
import Types exposing (..)


-- ─── Ports ───────────────────────────────────────────────────────────────────

port copyToClipboard : String -> Cmd msg
port copyResult : (Bool -> msg) -> Sub msg


-- ─── Main ────────────────────────────────────────────────────────────────────

main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( init, Cmd.none )
        , update = update
        , subscriptions = \_ -> copyResult CopyResult
        , view = view
        }


-- ─── Model ───────────────────────────────────────────────────────────────────

type alias Model =
    { spellName : String
    , seedInstances : List SeedInstance
    , nextInstanceId : SeedInstanceId
    , appliedFactors : List AppliedFactor
    , description : String
    , seedsPanelOpen : Bool
    , factorsPanelOpen : Bool
    , summaryPanelOpen : Bool
    , copySuccess : Maybe Bool  -- Nothing = not attempted, Just True/False = result
    }


init : Model
init =
    { spellName = ""
    , seedInstances = []
    , nextInstanceId = 0
    , appliedFactors = []
    , description = ""
    , seedsPanelOpen = True
    , factorsPanelOpen = True
    , summaryPanelOpen = True
    , copySuccess = Nothing
    }


-- ─── Msg ─────────────────────────────────────────────────────────────────────

type Msg
    = SetSpellName String
    | AddSeedInstance SeedId
    | RemoveSeedInstance SeedInstanceId
    | SelectMode SeedInstanceId String
    | SetSeedFactor SeedInstanceId String Int      -- instanceId, factorId, quantity
    | SetChoice SeedInstanceId String String       -- instanceId, choiceId, value
    | AddGlobalFactor FactorId
    | RemoveGlobalFactor FactorId
    | SetGlobalFactorQty FactorId Int
    | SetDescription String
    | RegenerateDescription
    | ToggleSeedsPanel
    | ToggleFactorsPanel
    | ToggleSummaryPanel
    | ExportMarkdown
    | CopyResult Bool


-- ─── Update ──────────────────────────────────────────────────────────────────

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSpellName name ->
            ( { model | spellName = name }, Cmd.none )

        AddSeedInstance seedId ->
            let
                newInstance =
                    { instanceId = model.nextInstanceId
                    , seedId = seedId
                    , selectedMode = Nothing
                    , appliedSeedFactors = []
                    , choices = Dict.empty
                    }
            in
            ( { model
                | seedInstances = model.seedInstances ++ [ newInstance ]
                , nextInstanceId = model.nextInstanceId + 1
              }
            , Cmd.none
            )

        RemoveSeedInstance iid ->
            ( { model | seedInstances = List.filter (\i -> i.instanceId /= iid) model.seedInstances }
            , Cmd.none
            )

        SelectMode iid modeId ->
            ( { model
                | seedInstances =
                    List.map
                        (\i ->
                            if i.instanceId == iid then
                                { i | selectedMode = Just modeId, appliedSeedFactors = [] }
                            else
                                i
                        )
                        model.seedInstances
              }
            , Cmd.none
            )

        SetSeedFactor iid factorId qty ->
            ( { model
                | seedInstances =
                    List.map
                        (\i ->
                            if i.instanceId == iid then
                                let
                                    existing =
                                        List.filter (\asf -> asf.factorId /= factorId) i.appliedSeedFactors

                                    updated =
                                        if qty > 0 then
                                            existing ++ [ { factorId = factorId, quantity = qty } ]
                                        else
                                            existing
                                in
                                { i | appliedSeedFactors = updated }
                            else
                                i
                        )
                        model.seedInstances
              }
            , Cmd.none
            )

        SetChoice iid choiceId value ->
            ( { model
                | seedInstances =
                    List.map
                        (\i ->
                            if i.instanceId == iid then
                                { i | choices = Dict.insert choiceId value i.choices }
                            else
                                i
                        )
                        model.seedInstances
              }
            , Cmd.none
            )

        AddGlobalFactor factorId ->
            let
                alreadyApplied =
                    List.any (\af -> af.factorId == factorId) model.appliedFactors
            in
            if alreadyApplied then
                ( model, Cmd.none )
            else
                ( { model | appliedFactors = model.appliedFactors ++ [ { factorId = factorId, quantity = 1 } ] }
                , Cmd.none
                )

        RemoveGlobalFactor factorId ->
            ( { model | appliedFactors = List.filter (\af -> af.factorId /= factorId) model.appliedFactors }
            , Cmd.none
            )

        SetGlobalFactorQty factorId qty ->
            if qty <= 0 then
                ( { model | appliedFactors = List.filter (\af -> af.factorId /= factorId) model.appliedFactors }
                , Cmd.none
                )
            else
                ( { model
                    | appliedFactors =
                        List.map
                            (\af ->
                                if af.factorId == factorId then
                                    { af | quantity = qty }
                                else
                                    af
                            )
                            model.appliedFactors
                  }
                , Cmd.none
                )

        SetDescription text ->
            ( { model | description = text }, Cmd.none )

        RegenerateDescription ->
            let
                generated =
                    Export.generateDescription model.seedInstances model.appliedFactors
            in
            ( { model | description = generated }, Cmd.none )

        ToggleSeedsPanel ->
            ( { model | seedsPanelOpen = not model.seedsPanelOpen }, Cmd.none )

        ToggleFactorsPanel ->
            ( { model | factorsPanelOpen = not model.factorsPanelOpen }, Cmd.none )

        ToggleSummaryPanel ->
            ( { model | summaryPanelOpen = not model.summaryPanelOpen }, Cmd.none )

        ExportMarkdown ->
            let
                markdown =
                    Export.generateMarkdown
                        model.spellName
                        model.seedInstances
                        model.appliedFactors
                        model.description
                        0
            in
            ( { model | copySuccess = Nothing }, copyToClipboard markdown )

        CopyResult success ->
            ( { model | copySuccess = Just success }, Cmd.none )


-- ─── View ────────────────────────────────────────────────────────────────────

view : Model -> Html Msg
view model =
    let
        breakdown =
            calculateBreakdown model.seedInstances model.appliedFactors

        costs =
            devCosts breakdown.finalDC

        sb =
            statBlock model.seedInstances model.appliedFactors 0
    in
    div [ class "flex flex-col h-screen bg-gray-950 text-gray-100 overflow-hidden" ]
        [ viewHeader model breakdown
        , div [ class "flex flex-1 overflow-hidden" ]
            [ viewSeedsPanel model
            , viewFactorsPanel model breakdown
            , viewSummaryPanel model breakdown costs sb
            ]
        ]


viewHeader : Model -> DcBreakdown -> Html Msg
viewHeader model breakdown =
    div [ class "flex items-center justify-between px-6 py-3 bg-gray-900 border-b border-gray-700 shrink-0" ]
        [ input
            [ class "bg-transparent text-2xl font-bold text-gray-100 outline-none placeholder-gray-600 w-96"
            , placeholder "Unnamed Spell"
            , value model.spellName
            , onInput SetSpellName
            ]
            []
        , div [ class "flex items-center gap-3" ]
            [ span [ class "text-gray-400 text-sm uppercase tracking-widest" ] [ text "Spellcraft DC" ]
            , span [ class "text-arcane-400 text-4xl font-bold tabular-nums" ]
                [ text (String.fromInt breakdown.finalDC) ]
            ]
        ]


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
                , -- Mode selector (if seed has modes)
                  if List.isEmpty seed.modes then
                    text ""
                  else
                    div [ class "mb-2" ]
                        [ select
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
                , -- Choice dropdowns
                  div [] (List.map (viewChoiceDropdown inst) seed.choices)
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


-- ─── Factors panel ───────────────────────────────────────────────────────────

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
            in
            if List.isEmpty availableFactors then
                text ""

            else
                div [ class "border-b border-gray-800" ]
                    [ div [ class "px-4 py-2 bg-gray-900 text-xs text-arcane-400 font-semibold uppercase tracking-wider" ]
                        [ text ("── " ++ seed.name ++ " ──") ]
                    , div [ class "px-4 py-2" ]
                        (List.map (viewSeedFactor inst) availableFactors)
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

        dcLabel =
            if sf.dcModifier == 0 then
                "(special)"
            else if sf.dcModifier > 0 then
                "+" ++ String.fromInt (sf.dcModifier * Basics.max 1 currentQty) ++ " DC"
            else
                String.fromInt (sf.dcModifier * Basics.max 1 currentQty) ++ " DC"
    in
    div [ class "flex items-center justify-between py-1 gap-2 text-sm" ]
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
                            (SetSeedFactor inst.instanceId sf.id
                                (if currentQty > 0 then 0 else 1)
                            )
                        ]
                        [ text (if currentQty > 0 then "On" else "Off") ]

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
                                (SetSeedFactor inst.instanceId sf.id
                                    (case sf.maxQuantity of
                                        Nothing -> currentQty + 1
                                        Just mx -> Basics.min mx (currentQty + 1)
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

        appliedInCategory =
            List.filter
                (\af ->
                    getFactor af.factorId
                        |> Maybe.map (\f -> f.category == category)
                        |> Maybe.withDefault False
                )
                model.appliedFactors

        unapplied =
            List.filter
                (\f -> not (List.any (\af -> af.factorId == f.id) appliedInCategory))
                categoryFactors
    in
    div [ class "border-b border-gray-800" ]
        [ div [ class "px-4 py-2 bg-gray-900 text-xs text-gray-400 font-semibold uppercase tracking-wider" ]
            [ text ("── Global " ++ label ++ " ──") ]
        , div [ class "px-4 py-2" ]
            (List.map (viewAppliedGlobalFactor model) appliedInCategory
                ++ [ viewAddFactorDropdown unapplied label ]
            )
        ]


viewAppliedGlobalFactor : Model -> AppliedFactor -> Html Msg
viewAppliedGlobalFactor _ af =
    case getFactor af.factorId of
        Nothing ->
            text ""

        Just factor ->
            let
                dcDisplay =
                    case factor.kind of
                        Toggle ->
                            if factor.dcModifier > 0 then
                                "+" ++ String.fromInt factor.dcModifier ++ " DC"
                            else
                                String.fromInt factor.dcModifier ++ " DC"

                        Stackable ->
                            let total = factor.dcModifier * af.quantity
                            in
                            (if total > 0 then "+" else "") ++ String.fromInt total ++ " DC"

                        DcMultiplier ->
                            "×" ++ String.fromInt factor.multiplierValue
            in
            div [ class "flex items-center justify-between py-1 gap-2 text-sm" ]
                [ div [ class "flex-1 min-w-0" ]
                    [ div [ class "text-gray-200 text-xs truncate" ] [ text factor.name ]
                    , div [ class "text-gray-500 text-xs" ] [ text factor.shortDesc ]
                    ]
                , div [ class "flex items-center gap-1 shrink-0" ]
                    [ span [ class "text-gray-500 text-xs w-16 text-right" ] [ text dcDisplay ]
                    , case factor.kind of
                        Toggle ->
                            button
                                [ class "w-5 h-5 rounded bg-arcane-500 hover:bg-red-600 text-white text-xs flex items-center justify-center"
                                , onClick (RemoveGlobalFactor factor.id)
                                , title "Remove"
                                ]
                                [ text "✕" ]

                        DcMultiplier ->
                            button
                                [ class "w-5 h-5 rounded bg-arcane-500 hover:bg-red-600 text-white text-xs flex items-center justify-center"
                                , onClick (RemoveGlobalFactor factor.id)
                                , title "Remove"
                                ]
                                [ text "✕" ]

                        Stackable ->
                            div [ class "flex items-center gap-1" ]
                                [ button
                                    [ class "w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center"
                                    , onClick (SetGlobalFactorQty factor.id (Basics.max 0 (af.quantity - 1)))
                                    -- quantity 0 = remove
                                    ]
                                    [ text "−" ]
                                , span [ class "text-xs text-gray-300 w-4 text-center tabular-nums" ]
                                    [ text (String.fromInt af.quantity) ]
                                , button
                                    [ class "w-5 h-5 rounded bg-gray-700 hover:bg-gray-600 text-gray-300 text-xs flex items-center justify-center"
                                    , onClick (SetGlobalFactorQty factor.id (af.quantity + 1))
                                    ]
                                    [ text "+" ]
                                , button
                                    [ class "ml-1 w-5 h-5 rounded bg-gray-800 hover:bg-red-700 text-gray-500 hover:text-white text-xs flex items-center justify-center"
                                    , onClick (RemoveGlobalFactor factor.id)
                                    , title "Remove"
                                    ]
                                    [ text "✕" ]
                                ]
                    ]
                ]


viewAddFactorDropdown : List Factor -> String -> Html Msg
viewAddFactorDropdown unapplied label =
    if List.isEmpty unapplied then
        div [ class "text-gray-600 text-xs py-2 text-center" ] [ text ("All " ++ label ++ " factors applied") ]

    else
        select
            [ class "w-full bg-gray-800 text-gray-300 text-xs rounded px-2 py-1 border border-gray-700 mt-1"
            , onInput
                (\idStr ->
                    case factorIdFromString idStr of
                        Just fId -> AddGlobalFactor fId
                        Nothing  -> ExportMarkdown  -- no-op fallback; harmless
                )
            ]
            (option [ value "" ] [ text ("+ Add " ++ label ++ " factor…") ]
                :: List.map
                    (\f ->
                        option [ value (factorIdToString f.id) ]
                            [ text f.name ]
                    )
                    unapplied
            )


-- ─── FactorId helpers ─────────────────────────────────────────────────────────

factorIdToString : FactorId -> String
factorIdToString fid =
    case fid of
        ReduceCastTime1Round -> "ReduceCastTime1Round"
        OneActionCastTime    -> "OneActionCastTime"
        QuickenedSpell       -> "QuickenedSpell"
        Contingent           -> "Contingent"
        NoVerbal             -> "NoVerbal"
        NoSomatic            -> "NoSomatic"
        IncreaseDuration     -> "IncreaseDuration"
        PermanentDuration    -> "PermanentDuration"
        Dismissible          -> "Dismissible"
        IncreaseRange        -> "IncreaseRange"
        AddExtraTarget       -> "AddExtraTarget"
        TargetToArea         -> "TargetToArea"
        PersonalToArea       -> "PersonalToArea"
        TargetToTouch        -> "TargetToTouch"
        TouchToTarget        -> "TouchToTarget"
        ChangeToBolt         -> "ChangeToBolt"
        ChangeToCylinder     -> "ChangeToCylinder"
        ChangeToCone         -> "ChangeToCone"
        ChangeToFourCubes    -> "ChangeToFourCubes"
        ChangeToRadius       -> "ChangeToRadius"
        AreaToTarget         -> "AreaToTarget"
        AreaToTouch          -> "AreaToTouch"
        IncreaseArea         -> "IncreaseArea"
        IncreaseSaveDC       -> "IncreaseSaveDC"
        IncreaseSRCheck      -> "IncreaseSRCheck"
        IncreaseVsDispel     -> "IncreaseVsDispel"
        StoneTablet          -> "StoneTablet"
        IncreaseDamageDie    -> "IncreaseDamageDie"
        Backlash             -> "Backlash"
        XPBurn               -> "XPBurn"
        IncreaseCastTime1Min -> "IncreaseCastTime1Min"
        IncreaseCastTime1Day -> "IncreaseCastTime1Day"
        ChangeToPersonal     -> "ChangeToPersonal"
        DecreaseDamageDie    -> "DecreaseDamageDie"
        RitualSlot1          -> "RitualSlot1"
        RitualSlot2          -> "RitualSlot2"
        RitualSlot3          -> "RitualSlot3"
        RitualSlot4          -> "RitualSlot4"
        RitualSlot5          -> "RitualSlot5"
        RitualSlot6          -> "RitualSlot6"
        RitualSlot7          -> "RitualSlot7"
        RitualSlot8          -> "RitualSlot8"
        RitualSlot9          -> "RitualSlot9"
        RitualSlotEpic       -> "RitualSlotEpic"


factorIdFromString : String -> Maybe FactorId
factorIdFromString s =
    allFactors
        |> List.filter (\f -> factorIdToString f.id == s)
        |> List.head
        |> Maybe.map .id


-- ─── Summary panel ───────────────────────────────────────────────────────────

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
    div []
        [ div [ class "flex items-center justify-between mb-1" ]
            [ span [ class "text-xs font-bold uppercase tracking-widest text-gray-400" ] [ text "Description" ]
            , button
                [ class "text-xs text-arcane-400 hover:text-arcane-500 underline"
                , onClick RegenerateDescription
                ]
                [ text "Regenerate" ]
            ]
        , textarea
            [ class "w-full bg-gray-800 text-gray-200 text-xs rounded p-2 border border-gray-700 resize-none h-40 focus:outline-none focus:border-arcane-500"
            , value model.description
            , onInput SetDescription
            , placeholder "Description will appear here after adding seeds and clicking Regenerate."
            ]
            []
        ]


viewExportButton : Model -> Html Msg
viewExportButton model =
    div []
        [ button
            [ class "w-full py-2 rounded bg-arcane-500 hover:bg-arcane-400 text-white text-sm font-semibold"
            , onClick ExportMarkdown
            ]
            [ text "Export Markdown" ]
        , case model.copySuccess of
            Just True ->
                div [ class "text-green-400 text-xs text-center mt-1" ] [ text "Copied to clipboard!" ]
            Just False ->
                div [ class "text-red-400 text-xs text-center mt-1" ] [ text "Copy failed — check browser permissions." ]
            Nothing ->
                text ""
        ]
