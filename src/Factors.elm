module Factors exposing (allFactors, getFactor)

import Types exposing (..)


allFactors : List Factor
allFactors =
    augmentingFactors ++ mitigatingFactors


getFactor : FactorId -> Maybe Factor
getFactor id =
    List.head (List.filter (\f -> f.id == id) allFactors)



-- ─── Augmenting Factors ───────────────────────────────────────────────────────


augmentingFactors : List Factor
augmentingFactors =
    [ -- Casting Time
      { id = ReduceCastTime1Round, name = "Reduce casting time by 1 round", category = Augmenting, kind = Stackable, dcModifier = 2, multiplierValue = 1, statBlockField = FieldCastingTime, shortDesc = "minimum 1 round", section = "Casting Time" }
    , { id = OneActionCastTime, name = "1-action casting time", category = Augmenting, kind = Toggle, dcModifier = 20, multiplierValue = 1, statBlockField = FieldCastingTime, shortDesc = "Reduces to standard action", section = "Casting Time" }
    , { id = QuickenedSpell, name = "Quickened spell", category = Augmenting, kind = Toggle, dcModifier = 28, multiplierValue = 1, statBlockField = FieldCastingTime, shortDesc = "Cast as a free action; max 1/round", section = "Casting Time" }
    , { id = Contingent, name = "Contingent on specific trigger", category = Augmenting, kind = Toggle, dcModifier = 25, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "", section = "Casting Time" }

    -- Components
    , { id = NoVerbal, name = "No verbal component", category = Augmenting, kind = Toggle, dcModifier = 2, multiplierValue = 1, statBlockField = FieldComponents, shortDesc = "", section = "Components" }
    , { id = NoSomatic, name = "No somatic component", category = Augmenting, kind = Toggle, dcModifier = 2, multiplierValue = 1, statBlockField = FieldComponents, shortDesc = "", section = "Components" }

    -- Duration
    , { id = IncreaseDuration, name = "Increase duration 100%", category = Augmenting, kind = Stackable, dcModifier = 2, multiplierValue = 1, statBlockField = FieldDuration, shortDesc = "", section = "Duration" }
    , { id = PermanentDuration, name = "Permanent duration", category = Augmenting, kind = DcMultiplier, dcModifier = 0, multiplierValue = 5, statBlockField = FieldDuration, shortDesc = "", section = "Duration" }
    , { id = Dismissible, name = "Dismissible by caster", category = Augmenting, kind = Toggle, dcModifier = 2, multiplierValue = 1, statBlockField = FieldDuration, shortDesc = "Adds (D) tag if not already", section = "Duration" }

    -- Range
    , { id = IncreaseRange, name = "Increase range 100%", category = Augmenting, kind = Stackable, dcModifier = 2, multiplierValue = 1, statBlockField = FieldRange, shortDesc = "", section = "Range" }

    -- Targets
    , { id = AddExtraTarget, name = "Add extra target within 300 ft.", category = Augmenting, kind = Stackable, dcModifier = 10, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "+1 target per application", section = "Target" }
    , { id = TargetToArea, name = "Target → area", category = Augmenting, kind = Toggle, dcModifier = 10, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "Changes targeting to area", section = "Target" }
    , { id = PersonalToArea, name = "Personal → area", category = Augmenting, kind = Toggle, dcModifier = 15, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "Changes personal to area", section = "Target" }
    , { id = TargetToTouch, name = "Target → touch/ray (300 ft. range)", category = Augmenting, kind = Toggle, dcModifier = 4, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "", section = "Target" }
    , { id = TouchToTarget, name = "Touch/ray → target", category = Augmenting, kind = Toggle, dcModifier = 4, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "", section = "Target" }

    -- Area
    , { id = ChangeToBolt, name = "Change area to bolt", category = Augmenting, kind = Toggle, dcModifier = 2, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "5 ft. x 300 ft. OR 10 ft. x 150 ft.", section = "Area" }
    , { id = ChangeToCylinder, name = "Change area to cylinder", category = Augmenting, kind = Toggle, dcModifier = 2, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "10-ft. radius, 30 ft. high", section = "Area" }
    , { id = ChangeToCone, name = "Change area to 40-ft. cone", category = Augmenting, kind = Toggle, dcModifier = 2, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "", section = "Area" }
    , { id = ChangeToFourCubes, name = "Change area to four 10-ft. cubes", category = Augmenting, kind = Toggle, dcModifier = 2, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "", section = "Area" }
    , { id = ChangeToRadius, name = "Change area to 20-ft. radius", category = Augmenting, kind = Toggle, dcModifier = 2, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "", section = "Area" }
    , { id = AreaToTarget, name = "Area → target", category = Augmenting, kind = Toggle, dcModifier = 4, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "", section = "Area" }
    , { id = AreaToTouch, name = "Area → touch/ray", category = Augmenting, kind = Toggle, dcModifier = 4, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "Close range (25 ft. + 5 ft./2 levels)", section = "Area" }
    , { id = IncreaseArea, name = "Increase area 100%", category = Augmenting, kind = Stackable, dcModifier = 4, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "", section = "Area" }

    -- Save DC
    , { id = IncreaseSaveDC, name = "Increase save DC by +1", category = Augmenting, kind = Stackable, dcModifier = 2, multiplierValue = 1, statBlockField = FieldSaveDC, shortDesc = "", section = "Saving Throw" }

    -- Spell Resistance
    , { id = IncreaseSRCheck, name = "+1 to caster level check vs. SR", category = Augmenting, kind = Stackable, dcModifier = 2, multiplierValue = 1, statBlockField = FieldSpellResistance, shortDesc = "", section = "Spell Resistance" }
    , { id = IncreaseVsDispel, name = "+1 vs. dispel effects", category = Augmenting, kind = Stackable, dcModifier = 2, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "", section = "Spell Resistance" }

    -- Other
    , { id = StoneTablet, name = "Recorded onto stone tablet", category = Augmenting, kind = DcMultiplier, dcModifier = 0, multiplierValue = 2, statBlockField = FieldNone, shortDesc = "x2 multiplier on total DC", section = "Other" }
    , { id = IncreaseDamageDie, name = "Increase damage die +1 step", category = Augmenting, kind = Stackable, dcModifier = 10, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "max d20", section = "Other" }
    ]



-- ─── Mitigating Factors ───────────────────────────────────────────────────────


mitigatingFactors : List Factor
mitigatingFactors =
    [ { id = Backlash, name = "Backlash (1d6 per die to caster)", category = Mitigating, kind = Stackable, dcModifier = -1, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "Caster takes Xd6 on casting or per round (max = HD×2 dice)", section = "Other" }
    , { id = XPBurn, name = "XP burn (per 100 XP)", category = Mitigating, kind = Stackable, dcModifier = -1, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "Max 20,000 XP (-200 DC)", section = "Other" }
    , { id = IncreaseCastTime1Min, name = "Increase casting time +1 minute", category = Mitigating, kind = Stackable, dcModifier = -2, multiplierValue = 1, statBlockField = FieldCastingTime, shortDesc = "Max 10 min total", section = "Casting Time" }
    , { id = IncreaseCastTime1Day, name = "Increase casting time +1 day", category = Mitigating, kind = Stackable, dcModifier = -2, multiplierValue = 1, statBlockField = FieldCastingTime, shortDesc = "After reaching 10 min; max 100 days", section = "Casting Time" }
    , { id = ChangeToPersonal, name = "Change target/touch/area → personal", category = Mitigating, kind = Toggle, dcModifier = -2, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "", section = "Target" }
    , { id = DecreaseDamageDie, name = "Decrease damage die -1 step", category = Mitigating, kind = Stackable, dcModifier = -5, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "Min d4", section = "Other" }

    -- Ritual participants (each slot level is a separate factor; quantity = number of participants at that slot level)
    , { id = RitualSlot1, name = "Ritual: 1st-level spell slot", category = Mitigating, kind = Stackable, dcModifier = -1, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "-1 DC per participant", section = "Ritual" }
    , { id = RitualSlot2, name = "Ritual: 2nd-level spell slot", category = Mitigating, kind = Stackable, dcModifier = -3, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "-3 DC per participant", section = "Ritual" }
    , { id = RitualSlot3, name = "Ritual: 3rd-level spell slot", category = Mitigating, kind = Stackable, dcModifier = -5, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "-5 DC per participant", section = "Ritual" }
    , { id = RitualSlot4, name = "Ritual: 4th-level spell slot", category = Mitigating, kind = Stackable, dcModifier = -7, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "-7 DC per participant", section = "Ritual" }
    , { id = RitualSlot5, name = "Ritual: 5th-level spell slot", category = Mitigating, kind = Stackable, dcModifier = -9, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "-9 DC per participant", section = "Ritual" }
    , { id = RitualSlot6, name = "Ritual: 6th-level spell slot", category = Mitigating, kind = Stackable, dcModifier = -11, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "-11 DC per participant", section = "Ritual" }
    , { id = RitualSlot7, name = "Ritual: 7th-level spell slot", category = Mitigating, kind = Stackable, dcModifier = -13, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "-13 DC per participant", section = "Ritual" }
    , { id = RitualSlot8, name = "Ritual: 8th-level spell slot", category = Mitigating, kind = Stackable, dcModifier = -15, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "-15 DC per participant", section = "Ritual" }
    , { id = RitualSlot9, name = "Ritual: 9th-level spell slot", category = Mitigating, kind = Stackable, dcModifier = -17, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "-17 DC per participant", section = "Ritual" }
    , { id = RitualSlotEpic, name = "Ritual: Epic spell slot", category = Mitigating, kind = Stackable, dcModifier = -19, multiplierValue = 1, statBlockField = FieldNone, shortDesc = "-19 DC per participant", section = "Ritual" }
    ]
