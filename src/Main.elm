module Main exposing (main)

import Browser
import Calc exposing (calculateBreakdown, devCosts, statBlock)
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


-- ─── View placeholder (replaced section by section) ──────────────────────────

view : Model -> Html Msg
view model =
    let
        breakdown =
            calculateBreakdown model.seedInstances model.appliedFactors

        costs =
            devCosts breakdown.finalDC
    in
    div [ class "p-8 text-gray-100" ]
        [ div [ class "text-arcane-400 text-3xl font-bold mb-4" ] [ text "Epic Spell Wizard" ]
        , div [] [ text ("Final DC: " ++ String.fromInt breakdown.finalDC) ]
        , div [] [ text ("Gold: " ++ String.fromInt costs.goldCost) ]
        ]
