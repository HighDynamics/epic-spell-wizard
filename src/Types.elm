module Types exposing (..)

import Dict exposing (Dict)



-- ─── IDs ─────────────────────────────────────────────────────────────────────


type SeedId
    = Afflict
    | Animate
    | AnimateDead
    | Armor
    | Banish
    | Compel
    | Conceal
    | Conjure
    | Contact
    | Delude
    | Destroy
    | Dispel
    | Energy
    | Foresee
    | Fortify
    | Heal
    | Life
    | Reflect
    | Reveal
    | Slay
    | Summon
    | Transform
    | Transport
    | Ward


type FactorId
    = ReduceCastTime1Round
    | OneActionCastTime
    | QuickenedSpell
    | Contingent
    | NoVerbal
    | NoSomatic
    | IncreaseDuration
    | PermanentDuration
    | Dismissible
    | IncreaseRange
    | AddExtraTarget
    | TargetToArea
    | PersonalToArea
    | TargetToTouch
    | TouchToTarget
    | ChangeToBolt
    | ChangeToCylinder
    | ChangeToCone
    | ChangeToFourCubes
    | ChangeToRadius
    | AreaToTarget
    | AreaToTouch
    | IncreaseArea
    | IncreaseSaveDC
    | IncreaseSRCheck
    | IncreaseVsDispel
    | StoneTablet
    | IncreaseDamageDie
    | Backlash
    | XPBurn
    | IncreaseCastTime1Min
    | IncreaseCastTime1Day
    | ChangeToPersonal
    | DecreaseDamageDie
    | RitualSlot1
    | RitualSlot2
    | RitualSlot3
    | RitualSlot4
    | RitualSlot5
    | RitualSlot6
    | RitualSlot7
    | RitualSlot8
    | RitualSlot9
    | RitualSlotEpic



-- ─── Seed building blocks ────────────────────────────────────────────────────


type Component
    = V
    | S
    | M
    | DF
    | F
    | XP


type SavingThrowType
    = WillSave
    | ReflexSave
    | FortSave


type SaveEffect
    = Negates
    | Half
    | Partial
    | SeeText


type alias SavingThrow =
    { saveType : SavingThrowType
    , effect : SaveEffect
    , harmless : Bool
    }


type SeedFactorKind
    = SeedToggle
    | SeedStackable



-- A DC adjustment specific to one seed (from that seed's own rules text).


type alias SeedFactor =
    { id : String
    , name : String
    , description : String
    , dcModifier : Int -- per unit (negative = reduces DC)
    , kind : SeedFactorKind
    , maxQuantity : Maybe Int -- Nothing = unlimited
    }



-- A named mode within a seed (e.g. Energy → Bolt, Emanation, Wall).
-- Modes are mutually exclusive within a single seed instance.


type alias SeedMode =
    { id : String
    , name : String
    , baseDCOverride : Maybe Int -- overrides seed baseDC when this mode is active (e.g. Contact Messenger = 20)
    , factors : List SeedFactor
    }



-- A free-choice option on a seed instance (no DC cost).
-- E.g. Energy type (fire/cold/etc.), Ward type (damage/energy/creature/magic).


type alias SeedChoice =
    { id : String
    , label : String
    , options : List String
    , default : String
    }


type alias Seed =
    { id : SeedId
    , name : String
    , baseDC : Int
    , school : String
    , descriptors : List String -- e.g. ["Fire"], ["Evil"], ["Mind-Affecting"]
    , components : List Component
    , castingTime : String
    , range : String
    , targetAreaEffect : String
    , duration : String
    , savingThrow : Maybe SavingThrow
    , spellResistance : Bool
    , description : String -- base prose (full SRD description)
    , modes : List SeedMode -- empty if seed has no modes
    , universalFactors : List SeedFactor -- factors available regardless of mode ("Mode: Any")
    , choices : List SeedChoice -- free-choice options (energy type, etc.)
    }



-- ─── Global factors ───────────────────────────────────────────────────────────


type FactorKind
    = Toggle -- on/off, applies once
    | Stackable -- quantity × dcModifier
    | DcMultiplier -- multiplies running total (Permanent ×5, StoneTablet ×2)


type FactorCategory
    = Augmenting
    | Mitigating



-- Which part of the spell stat block this factor modifies.


type StatBlockField
    = FieldComponents
    | FieldCastingTime
    | FieldRange
    | FieldTargetArea
    | FieldDuration
    | FieldSaveDC
    | FieldSpellResistance
    | FieldNone -- DC-only change


type alias Factor =
    { id : FactorId
    , name : String
    , category : FactorCategory
    , kind : FactorKind
    , dcModifier : Int -- per unit; ignored for DcMultiplier (handled separately)
    , multiplierValue : Int -- only meaningful for DcMultiplier kind (5 or 2)
    , statBlockField : StatBlockField
    , shortDesc : String -- shown in the factors panel
    }



-- ─── Model building blocks ───────────────────────────────────────────────────


type alias SeedInstanceId =
    Int


type alias AppliedSeedFactor =
    { factorId : String -- matches SeedFactor.id
    , quantity : Int
    }



-- One instance of a seed in the spell being built.
-- The same seed can be added multiple times (different modes).


type alias SeedInstance =
    { instanceId : SeedInstanceId
    , seedId : SeedId
    , selectedMode : Maybe String -- matches SeedMode.id; Nothing if seed has no modes
    , appliedSeedFactors : List AppliedSeedFactor
    , choices : Dict String String -- choiceId → selected value
    }


type alias AppliedFactor =
    { factorId : FactorId
    , quantity : Int
    }



-- ─── DC breakdown (computed, not stored) ─────────────────────────────────────


type alias DcBreakdown =
    { seedsTotal : Int
    , seedFactorsTotal : Int
    , augmentingTotal : Int
    , permanentMultiplier : Int -- 1 or 5
    , stoneTabletMultiplier : Int -- 1 or 2
    , mitigatingTotal : Int
    , finalDC : Int
    }



-- ─── Development costs (computed) ────────────────────────────────────────────


type alias DevCosts =
    { goldCost : Int
    , timeDays : Int
    , xpCost : Int
    }



-- ─── App state ───────────────────────────────────────────────────────────────


type alias Model =
    { spellName : String
    , seedInstances : List SeedInstance
    , nextInstanceId : SeedInstanceId
    , appliedFactors : List AppliedFactor
    , seedsPanelOpen : Bool
    , factorsPanelOpen : Bool
    , summaryPanelOpen : Bool
    , copySuccess : Maybe Bool
    }


type Msg
    = SetSpellName String
    | AddSeedInstance SeedId
    | RemoveSeedInstance SeedInstanceId
    | SelectMode SeedInstanceId String
    | SetSeedFactor SeedInstanceId String Int
    | SetChoice SeedInstanceId String String
    | AddGlobalFactor FactorId
    | RemoveGlobalFactor FactorId
    | SetGlobalFactorQty FactorId Int
    | ToggleSeedsPanel
    | ToggleFactorsPanel
    | ToggleSummaryPanel
    | ExportMarkdown
    | CopyResult Bool
