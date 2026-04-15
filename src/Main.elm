module Main exposing (main)

import Browser
import Calc exposing (StatBlockData, calculateBreakdown, devCosts, statBlock)
import Dict exposing (Dict)
import Factors exposing (allFactors, getFactor)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Seeds exposing (allSeeds, getSeed)
import Types exposing (..)


-- ─── Ports (wired in Section 11) ─────────────────────────────────────────────

-- Ports declared here so the module compiles; subscriptions added in Section 11.


-- ─── Main ────────────────────────────────────────────────────────────────────

main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( init, Cmd.none )
        , update = update
        , subscriptions = \_ -> Sub.none
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
            -- Description generation implemented in Section 10 (Export.elm).
            -- Placeholder: sets description to a join of seed names.
            let
                names =
                    model.seedInstances
                        |> List.filterMap (\i -> getSeed i.seedId |> Maybe.map .name)
                        |> String.join ", "
            in
            ( { model | description = "Spell using: " ++ names }, Cmd.none )

        ToggleSeedsPanel ->
            ( { model | seedsPanelOpen = not model.seedsPanelOpen }, Cmd.none )

        ToggleFactorsPanel ->
            ( { model | factorsPanelOpen = not model.factorsPanelOpen }, Cmd.none )

        ToggleSummaryPanel ->
            ( { model | summaryPanelOpen = not model.summaryPanelOpen }, Cmd.none )

        ExportMarkdown ->
            -- Clipboard port call implemented in Section 11.
            ( model, Cmd.none )

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


-- ─── Stub panels (replaced in Sections 8 and 9) ──────────────────────────────

viewFactorsPanel : Model -> DcBreakdown -> Html Msg
viewFactorsPanel _ _ =
    div [ class "flex-1 bg-gray-950 border-r border-gray-700 overflow-y-auto flex items-center justify-center text-gray-700 text-sm" ]
        [ text "Factors panel — Section 8" ]


viewSummaryPanel : Model -> DcBreakdown -> DevCosts -> StatBlockData -> Html Msg
viewSummaryPanel _ breakdown costs _ =
    div [ class "w-64 shrink-0 bg-gray-900 overflow-y-auto p-4" ]
        [ div [ class "text-arcane-400 text-xl font-bold" ] [ text ("DC: " ++ String.fromInt breakdown.finalDC) ]
        , div [ class "text-gray-400 text-sm mt-2" ] [ text ("Gold: " ++ String.fromInt costs.goldCost) ]
        ]
