module UrlStateTest exposing (suite)

import Dict
import Expect
import Factors exposing (allFactors)
import Seeds exposing (allSeeds)
import Set
import Test exposing (Test, describe, test)
import Types exposing (..)
import UrlState


emptyModel : Model
emptyModel =
    { spellName = ""
    , seedInstances = []
    , nextInstanceId = 0
    , primarySeedInstanceId = Nothing
    , appliedFactors = []
    , selectedSchool = Nothing
    , selectedSavingThrow = Nothing
    , targetToAreaShape = Nothing
    , personalToAreaShape = Nothing
    , boltShape = Nothing
    , expandedSeedDescriptions = Set.empty
    , collapsedSeedInstances = Set.empty
    , collapsedGlobalFactorSections = Set.empty
    , seedsPanelOpen = True
    , factorsPanelOpen = True
    , summaryPanelOpen = True
    , copySuccess = Nothing
    , pendingCopy = Nothing
    , exportFormat = PlainTextExport
    , baseUrl = ""
    , renamingSpell = False
    , helpModalOpen = False
    , licenseModalOpen = False
    , activeMobileTab = SeedsTab
    , importModalOpen = False
    , importInput = ""
    , importError = Nothing
    , isStandalone = False
    , clearSpellUndo = Nothing
    }


roundTrip : Model -> Model
roundTrip model =
    UrlState.applyQuery (UrlState.encode model) emptyModel


seedInstance : Seed -> SeedInstance
seedInstance seed =
    { instanceId = 0
    , seedId = seed.id
    , appliedSeedFactors = []
    , choices = Dict.empty
    , baseDCOverride = Nothing
    }


suite : Test
suite =
    describe "UrlState"
        [ test "an empty spell round-trips" <|
            \_ -> roundTrip emptyModel |> Expect.equal emptyModel
        , test "a spell name with reserved characters round-trips" <|
            \_ ->
                let
                    name =
                        "Bob's \"Fire\" (Ball)! ~100% & more *"
                in
                (roundTrip { emptyModel | spellName = name }).spellName
                    |> Expect.equal name
        , test "every seed round-trips" <|
            \_ ->
                allSeeds
                    |> List.filter
                        (\seed ->
                            (roundTrip { emptyModel | seedInstances = [ seedInstance seed ] }).seedInstances
                                |> List.map .seedId
                                |> (/=) [ seed.id ]
                        )
                    |> List.map .id
                    |> Expect.equal []
        , test "every global factor round-trips" <|
            \_ ->
                allFactors
                    |> List.filter
                        (\factor ->
                            (roundTrip { emptyModel | appliedFactors = [ { factorId = factor.id, quantity = 2 } ] }).appliedFactors
                                |> (/=) [ { factorId = factor.id, quantity = 2 } ]
                        )
                    |> List.map .id
                    |> Expect.equal []
        , test "extractQuery strips a pasted URL down to its query" <|
            \_ ->
                UrlState.extractQuery "  https://example.com/app/?name=Fireball&seeds=x  "
                    |> Expect.equal "?name=Fireball&seeds=x"
        ]
