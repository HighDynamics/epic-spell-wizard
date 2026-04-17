port module Main exposing (main)

import Browser
import Calc exposing (calculateBreakdown, devCosts, statBlock)
import Dict exposing (Dict)
import Export
import Html exposing (..)
import Html.Attributes exposing (class)
import Types exposing (..)
import View.FactorsPanel exposing (viewFactorsPanel)
import View.Header exposing (viewHeader)
import View.SeedsPanel exposing (viewSeedsPanel)
import View.SummaryPanel exposing (viewSummaryPanel)



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



-- ─── Init ────────────────────────────────────────────────────────────────────


init : Model
init =
    { spellName = ""
    , seedInstances = []
    , nextInstanceId = 0
    , primarySeedInstanceId = Nothing
    , appliedFactors = []
    , selectedSchool = Nothing
    , selectedSavingThrow = Nothing
    , seedsPanelOpen = True
    , factorsPanelOpen = True
    , summaryPanelOpen = True
    , copySuccess = Nothing
    }



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

                newPrimary =
                    case model.primarySeedInstanceId of
                        Nothing -> Just model.nextInstanceId
                        Just _ -> model.primarySeedInstanceId
            in
            ( { model
                | seedInstances = model.seedInstances ++ [ newInstance ]
                , nextInstanceId = model.nextInstanceId + 1
                , primarySeedInstanceId = newPrimary
              }
            , Cmd.none
            )

        RemoveSeedInstance iid ->
            let
                remaining =
                    List.filter (\i -> i.instanceId /= iid) model.seedInstances

                newPrimary =
                    if model.primarySeedInstanceId == Just iid then
                        List.head remaining |> Maybe.map .instanceId
                    else
                        model.primarySeedInstanceId
            in
            ( { model
                | seedInstances = remaining
                , primarySeedInstanceId = newPrimary
              }
            , Cmd.none
            )

        SetPrimarySeed iid ->
            ( { model | primarySeedInstanceId = Just iid }, Cmd.none )

        SetSchool school ->
            ( { model | selectedSchool = Just school }, Cmd.none )

        SetSavingThrow mst ->
            ( { model | selectedSavingThrow = mst }, Cmd.none )

        SelectMode iid modeId ->
            let
                newMode =
                    if String.isEmpty modeId then
                        Nothing

                    else
                        Just modeId
            in
            ( { model
                | seedInstances =
                    List.map
                        (\i ->
                            if i.instanceId == iid then
                                { i | selectedMode = newMode, appliedSeedFactors = [] }

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
                        (Export.generateDescription model.seedInstances model.appliedFactors)
                        0
                        model.primarySeedInstanceId
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
            statBlock model.seedInstances model.appliedFactors 0 model.primarySeedInstanceId model.selectedSchool model.selectedSavingThrow
    in
    div [ class "flex flex-col h-screen bg-gray-950 text-gray-100 overflow-hidden" ]
        [ viewHeader model breakdown
        , div [ class "flex flex-1 overflow-hidden" ]
            [ viewSeedsPanel model
            , viewFactorsPanel model breakdown
            , viewSummaryPanel model breakdown costs sb
            ]
        ]
