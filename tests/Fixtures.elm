module Fixtures exposing (emptyModel, seedInstance)

import Dict
import Set
import Types exposing (..)


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
    , houseRules = False
    , houseRulesConfirmOpen = False
    }


seedInstance : Seed -> SeedInstance
seedInstance seed =
    { instanceId = 0
    , seedId = seed.id
    , appliedSeedFactors = []
    , choices = Dict.empty
    , baseDCOverride = Nothing
    }
