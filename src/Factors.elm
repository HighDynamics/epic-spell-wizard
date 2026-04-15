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
      { id = ReduceCastTime1Round,  name = "Reduce casting time by 1 round",       category = Augmenting, kind = Stackable,    dcModifier = 1,  multiplierValue = 1, statBlockField = FieldCastingTime, shortDesc = "–1 round (min 1 round)" }
    , { id = OneActionCastTime,     name = "1-action casting time",                 category = Augmenting, kind = Toggle,       dcModifier = 20, multiplierValue = 1, statBlockField = FieldCastingTime, shortDesc = "Reduces to 1 action" }
    , { id = QuickenedSpell,        name = "Quickened spell (max 1/round)",         category = Augmenting, kind = Toggle,       dcModifier = 28, multiplierValue = 1, statBlockField = FieldCastingTime, shortDesc = "Free action; max 1/round" }
    , { id = Contingent,            name = "Contingent on trigger",                 category = Augmenting, kind = Toggle,       dcModifier = 25, multiplierValue = 1, statBlockField = FieldNone,        shortDesc = "Fires on specified trigger" }
    -- Components
    , { id = NoVerbal,              name = "No verbal component",                   category = Augmenting, kind = Toggle,       dcModifier = 2,  multiplierValue = 1, statBlockField = FieldComponents,  shortDesc = "Removes V component" }
    , { id = NoSomatic,             name = "No somatic component",                  category = Augmenting, kind = Toggle,       dcModifier = 2,  multiplierValue = 1, statBlockField = FieldComponents,  shortDesc = "Removes S component" }
    -- Duration
    , { id = IncreaseDuration,      name = "Increase duration 100%",                category = Augmenting, kind = Stackable,    dcModifier = 2,  multiplierValue = 1, statBlockField = FieldDuration,    shortDesc = "×2 per application" }
    , { id = PermanentDuration,     name = "Permanent duration",                    category = Augmenting, kind = Toggle,       dcModifier = 0,  multiplierValue = 5, statBlockField = FieldDuration,    shortDesc = "×5 multiplier on total DC" }
    , { id = Dismissible,           name = "Dismissible by caster",                 category = Augmenting, kind = Toggle,       dcModifier = 2,  multiplierValue = 1, statBlockField = FieldDuration,    shortDesc = "Adds (D) tag if not already" }
    -- Range
    , { id = IncreaseRange,         name = "Increase range 100%",                   category = Augmenting, kind = Stackable,    dcModifier = 2,  multiplierValue = 1, statBlockField = FieldRange,       shortDesc = "×2 per application" }
    -- Targets
    , { id = AddExtraTarget,        name = "Add extra target (within 300 ft.)",     category = Augmenting, kind = Stackable,    dcModifier = 10, multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "+1 target per application" }
    , { id = TargetToArea,          name = "Target → area",                         category = Augmenting, kind = Toggle,       dcModifier = 10, multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "Changes targeting to area" }
    , { id = PersonalToArea,        name = "Personal → area",                       category = Augmenting, kind = Toggle,       dcModifier = 15, multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "Changes personal to area" }
    , { id = TargetToTouch,         name = "Target → touch/ray (300 ft. range)",    category = Augmenting, kind = Toggle,       dcModifier = 4,  multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "" }
    , { id = TouchToTarget,         name = "Touch/ray → target",                    category = Augmenting, kind = Toggle,       dcModifier = 4,  multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "" }
    -- Area
    , { id = ChangeToBolt,          name = "Change area to bolt (5×300 or 10×150 ft.)", category = Augmenting, kind = Toggle,  dcModifier = 2,  multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "" }
    , { id = ChangeToCylinder,      name = "Change area to cylinder (10-ft. radius, 30 ft. high)", category = Augmenting, kind = Toggle, dcModifier = 2, multiplierValue = 1, statBlockField = FieldTargetArea, shortDesc = "" }
    , { id = ChangeToCone,          name = "Change area to 40-ft. cone",            category = Augmenting, kind = Toggle,       dcModifier = 2,  multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "" }
    , { id = ChangeToFourCubes,     name = "Change area to four 10-ft. cubes",      category = Augmenting, kind = Toggle,       dcModifier = 2,  multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "" }
    , { id = ChangeToRadius,        name = "Change area to 20-ft. radius",          category = Augmenting, kind = Toggle,       dcModifier = 2,  multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "" }
    , { id = AreaToTarget,          name = "Area → target",                         category = Augmenting, kind = Toggle,       dcModifier = 4,  multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "" }
    , { id = AreaToTouch,           name = "Area → touch/ray (close range)",        category = Augmenting, kind = Toggle,       dcModifier = 4,  multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "" }
    , { id = IncreaseArea,          name = "Increase area 100%",                    category = Augmenting, kind = Stackable,    dcModifier = 4,  multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "×2 per application" }
    -- Save DC
    , { id = IncreaseSaveDC,        name = "Increase save DC by +1",                category = Augmenting, kind = Stackable,    dcModifier = 2,  multiplierValue = 1, statBlockField = FieldSaveDC,      shortDesc = "+1 save DC per application" }
    -- Spell Resistance
    , { id = IncreaseSRCheck,       name = "+1 to caster level check vs. SR",       category = Augmenting, kind = Stackable,    dcModifier = 2,  multiplierValue = 1, statBlockField = FieldSpellResistance, shortDesc = "" }
    , { id = IncreaseVsDispel,      name = "+1 vs. dispel effects",                 category = Augmenting, kind = Stackable,    dcModifier = 2,  multiplierValue = 1, statBlockField = FieldNone,        shortDesc = "" }
    -- Other
    , { id = StoneTablet,           name = "Recorded onto stone tablet",            category = Augmenting, kind = DcMultiplier, dcModifier = 0,  multiplierValue = 2, statBlockField = FieldNone,        shortDesc = "×2 multiplier on total DC" }
    , { id = IncreaseDamageDie,     name = "Increase damage die +1 step",           category = Augmenting, kind = Stackable,    dcModifier = 10, multiplierValue = 1, statBlockField = FieldNone,        shortDesc = "+1 die step per application (max d20)" }
    ]


-- ─── Mitigating Factors ───────────────────────────────────────────────────────

mitigatingFactors : List Factor
mitigatingFactors =
    [ { id = Backlash,              name = "Backlash (1d6 per die to caster)",      category = Mitigating, kind = Stackable,    dcModifier = -1, multiplierValue = 1, statBlockField = FieldNone,        shortDesc = "Caster takes Xd6 on casting (max = HD×2 dice)" }
    , { id = XPBurn,                name = "XP burn (per 100 XP)",                  category = Mitigating, kind = Stackable,    dcModifier = -1, multiplierValue = 1, statBlockField = FieldNone,        shortDesc = "Max 20,000 XP (–200 DC)" }
    , { id = IncreaseCastTime1Min,  name = "Increase casting time +1 minute",       category = Mitigating, kind = Stackable,    dcModifier = -2, multiplierValue = 1, statBlockField = FieldCastingTime, shortDesc = "Max 10 min total" }
    , { id = IncreaseCastTime1Day,  name = "Increase casting time +1 day",          category = Mitigating, kind = Stackable,    dcModifier = -2, multiplierValue = 1, statBlockField = FieldCastingTime, shortDesc = "After reaching 10 min; max 100 days" }
    , { id = ChangeToPersonal,      name = "Change target/touch/area → personal",   category = Mitigating, kind = Toggle,       dcModifier = -2, multiplierValue = 1, statBlockField = FieldTargetArea,  shortDesc = "" }
    , { id = DecreaseDamageDie,     name = "Decrease damage die –1 step",           category = Mitigating, kind = Stackable,    dcModifier = -5, multiplierValue = 1, statBlockField = FieldNone,        shortDesc = "Min d4" }
    -- Ritual participants (each slot level is a separate factor; quantity = number of participants at that slot level)
    , { id = RitualSlot1,           name = "Ritual: 1st-level spell slot",          category = Mitigating, kind = Stackable,    dcModifier = -1, multiplierValue = 1, statBlockField = FieldNone,        shortDesc = "–1 DC per participant" }
    , { id = RitualSlot2,           name = "Ritual: 2nd-level spell slot",          category = Mitigating, kind = Stackable,    dcModifier = -3, multiplierValue = 1, statBlockField = FieldNone,        shortDesc = "–3 DC per participant" }
    , { id = RitualSlot3,           name = "Ritual: 3rd-level spell slot",          category = Mitigating, kind = Stackable,    dcModifier = -5, multiplierValue = 1, statBlockField = FieldNone,        shortDesc = "–5 DC per participant" }
    , { id = RitualSlot4,           name = "Ritual: 4th-level spell slot",          category = Mitigating, kind = Stackable,    dcModifier = -7, multiplierValue = 1, statBlockField = FieldNone,        shortDesc = "–7 DC per participant" }
    , { id = RitualSlot5,           name = "Ritual: 5th-level spell slot",          category = Mitigating, kind = Stackable,    dcModifier = -9, multiplierValue = 1, statBlockField = FieldNone,        shortDesc = "–9 DC per participant" }
    , { id = RitualSlot6,           name = "Ritual: 6th-level spell slot",          category = Mitigating, kind = Stackable,    dcModifier = -11, multiplierValue = 1, statBlockField = FieldNone,       shortDesc = "–11 DC per participant" }
    , { id = RitualSlot7,           name = "Ritual: 7th-level spell slot",          category = Mitigating, kind = Stackable,    dcModifier = -13, multiplierValue = 1, statBlockField = FieldNone,       shortDesc = "–13 DC per participant" }
    , { id = RitualSlot8,           name = "Ritual: 8th-level spell slot",          category = Mitigating, kind = Stackable,    dcModifier = -15, multiplierValue = 1, statBlockField = FieldNone,       shortDesc = "–15 DC per participant" }
    , { id = RitualSlot9,           name = "Ritual: 9th-level spell slot",          category = Mitigating, kind = Stackable,    dcModifier = -17, multiplierValue = 1, statBlockField = FieldNone,       shortDesc = "–17 DC per participant" }
    , { id = RitualSlotEpic,        name = "Ritual: Epic spell slot",               category = Mitigating, kind = Stackable,    dcModifier = -19, multiplierValue = 1, statBlockField = FieldNone,       shortDesc = "–19 DC per participant" }
    ]
