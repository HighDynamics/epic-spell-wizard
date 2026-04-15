module Seeds exposing (allSeeds, getSeed)

import Dict exposing (Dict)
import Types exposing (..)


-- ─── Lookup helpers ──────────────────────────────────────────────────────────

allSeeds : List Seed
allSeeds =
    [ afflict, animate, animateDead, armor, banish, compel
    , conceal, conjure, contact, delude, destroy, dispel, energy
    , foresee, fortify, heal, life, reflect, reveal, slay
    , summon, transform, transport, ward
    ]


getSeed : SeedId -> Maybe Seed
getSeed id =
    List.head (List.filter (\s -> s.id == id) allSeeds)


-- ─── Seeds ───────────────────────────────────────────────────────────────────

afflict : Seed
afflict =
    { id = Afflict
    , name = "Afflict"
    , baseDC = 14
    , school = "Enchantment (Compulsion)"
    , descriptors = [ "Fear", "Mind-Affecting" ]
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "300 ft."
    , targetAreaEffect = "One living creature"
    , duration = "20 minutes"
    , savingThrow = Just { saveType = WillSave, effect = Negates, harmless = False }
    , spellResistance = True
    , description = "Afflicts the target with a –2 morale penalty on attack rolls, checks, and saving throws. May also afflict ability scores, caster level checks, Spell Resistance, or senses. Ability scores can be reduced to 0 (Constitution minimum 1). Extended duration turns penalties into temporary damage; permanent duration makes them permanent drain."
    , modes = []
    , universalFactors =
        [ { id = "afflict_rolls", name = "Additional –1 to rolls/checks/saves", description = "Each additional –1 morale penalty beyond base –2", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "afflict_other", name = "–1 to ability score / CL check / SR / other", description = "Each –1 penalty in one of these categories", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "afflict_sense", name = "Afflict a sense", description = "One sense (sight, smell, hearing, taste, touch, or special) ceases to function for duration", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
        ]
    , choices = []
    }


animate : Seed
animate =
    { id = Animate
    , name = "Animate"
    , baseDC = 25
    , school = "Transmutation"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "300 ft."
    , targetAreaEffect = "Object or 20 cu. ft. of matter"
    , duration = "20 rounds"
    , savingThrow = Nothing
    , spellResistance = False
    , description = "Imbues inanimate objects with mobility and a semblance of life. The animated object attacks whomever the caster designates. Can animate part of a larger mass of raw matter (water, stone, earth) up to 20 cu. ft. base."
    , modes = []
    , universalFactors =
        [ { id = "animate_vol_1k", name = "Each additional 10 cu. ft. (up to 1,000)", description = "Increases animated volume beyond base 20 cu. ft., up to 1,000 cu. ft.", dcModifier = 1, kind = SeedStackable, maxQuantity = Just 98 }
        , { id = "animate_vol_over1k", name = "Each additional 100 cu. ft. (beyond 1,000)", description = "Increases animated volume beyond 1,000 cu. ft.", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "animate_hd", name = "Additional Hit Die for animated object", description = "Each additional HD granted to the animated object", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "animate_attended", name = "Animate attended objects", description = "Objects carried or worn by another creature", dcModifier = 10, kind = SeedToggle, maxQuantity = Just 1 }
        ]
    , choices = []
    }


animateDead : Seed
animateDead =
    { id = AnimateDead
    , name = "Animate Dead"
    , baseDC = 23
    , school = "Necromancy"
    , descriptors = [ "Evil" ]
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "Touch"
    , targetAreaEffect = "One or more corpses touched"
    , duration = "Instantaneous"
    , savingThrow = Nothing
    , spellResistance = False
    , description = "Animates 20 HD of undead from corpses. The undead follow the caster's commands indefinitely until destroyed. Caster can naturally control 1 HD per caster level of personally-created undead; excess become uncontrolled. Type of undead created affects DC (see table below)."
    , modes = []
    , universalFactors =
        [ { id = "adead_extra_hd_create", name = "Each additional 1 HD of undead created", description = "Above base 20 HD", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "adead_extra_hd_control", name = "Each additional 2 HD to control", description = "Control undead beyond free limit (above 20 HD created)", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
        -- Undead type modifiers (applied as a single toggle per type):
        , { id = "adead_skeleton",   name = "Undead type: Skeleton",  description = "DC modifier for skeleton type",  dcModifier = -12, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_zombie",     name = "Undead type: Zombie",    description = "DC modifier for zombie type",    dcModifier = -12, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_ghoul",      name = "Undead type: Ghoul",     description = "DC modifier for ghoul type",    dcModifier = -10, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_shadow",     name = "Undead type: Shadow",    description = "DC modifier for shadow type",   dcModifier = -8,  kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_ghast",      name = "Undead type: Ghast",     description = "DC modifier for ghast type",    dcModifier = -6,  kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_wight",      name = "Undead type: Wight",     description = "DC modifier for wight type",    dcModifier = -4,  kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_wraith",     name = "Undead type: Wraith",    description = "DC modifier for wraith type",   dcModifier = -2,  kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_mummy",      name = "Undead type: Mummy",     description = "DC modifier for mummy type",    dcModifier = 0,   kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_spectre",    name = "Undead type: Spectre",   description = "DC modifier for spectre type",  dcModifier = 2,   kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_mohrg",      name = "Undead type: Mohrg",     description = "DC modifier for mohrg type",    dcModifier = 4,   kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_vampire",    name = "Undead type: Vampire",   description = "DC modifier for vampire type",  dcModifier = 6,   kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_ghost",      name = "Undead type: Ghost",     description = "DC modifier for ghost type",    dcModifier = 8,   kind = SeedToggle, maxQuantity = Just 1 }
        ]
    , choices = []
    }


armor : Seed
armor =
    { id = Armor
    , name = "Armor"
    , baseDC = 14
    , school = "Conjuration (Creation)"
    , descriptors = [ "Force" ]
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "Touch"
    , targetAreaEffect = "Creature touched"
    , duration = "24 hours (D)"
    , savingThrow = Just { saveType = WillSave, effect = Negates, harmless = True }
    , spellResistance = True
    , description = "Grants a creature a +4 armor or natural armor bonus to AC (caster's choice). Provides no armor check penalty, arcane spell failure chance, or speed reduction. Incorporeal creatures cannot bypass this protection."
    , modes = []
    , universalFactors =
        [ { id = "armor_ac_bonus", name = "Each additional +1 armor/natural armor bonus", description = "Above base +4", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "armor_other_type", name = "Each +1 bonus of other type (deflection, divine, insight…)", description = "Bonus type other than armor/natural armor, per +1", dcModifier = 10, kind = SeedStackable, maxQuantity = Nothing }
        ]
    , choices = []
    }


banish : Seed
banish =
    { id = Banish
    , name = "Banish"
    , baseDC = 27
    , school = "Abjuration"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "75 ft."
    , targetAreaEffect = "One or more extraplanar creatures, no two more than 30 ft. apart"
    , duration = "Instantaneous"
    , savingThrow = Just { saveType = WillSave, effect = Negates, harmless = False }
    , spellResistance = True
    , description = "Forces extraplanar creatures out of the caster's home plane. Base effect banishes up to 14 HD of extraplanar creatures."
    , modes = []
    , universalFactors =
        [ { id = "banish_hd", name = "Each additional 2 HD banished", description = "Above base 14 HD", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "banish_type", name = "Specify non-outsider creature type/subtype", description = "Banish a creature type other than outsider", dcModifier = 20, kind = SeedToggle, maxQuantity = Just 1 }
        ]
    , choices = []
    }


compel : Seed
compel =
    { id = Compel
    , name = "Compel"
    , baseDC = 19
    , school = "Enchantment (Compulsion)"
    , descriptors = [ "Mind-Affecting" ]
    , components = [ V, M ]
    , castingTime = "1 minute"
    , range = "75 ft."
    , targetAreaEffect = "One living creature"
    , duration = "20 hours or until completed"
    , savingThrow = Just { saveType = WillSave, effect = Negates, harmless = False }
    , spellResistance = True
    , description = "Compels the target to follow a course of activity worded to sound reasonable. The activity can continue for the full duration, or until completed. The caster may specify trigger conditions instead of immediate compliance."
    , modes = []
    , universalFactors =
        [ { id = "compel_unreasonable", name = "Compel outright unreasonable / self-harmful action", description = "Removes the 'sounds reasonable' restriction", dcModifier = 10, kind = SeedToggle, maxQuantity = Just 1 }
        ]
    , choices = []
    }


conceal : Seed
conceal =
    { id = Conceal
    , name = "Conceal"
    , baseDC = 17
    , school = "Illusion (Glamer)"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "Personal or touch"
    , targetAreaEffect = "You or a creature or object of up to 2,000 lb."
    , duration = "200 minutes or until expended (D)"
    , savingThrow = Nothing
    , spellResistance = False
    , description = "Conceals a creature or object. Choose one mode: Invisibility, Displacement, or block Divination."
    , modes =
        [ { id = "conceal_invisibility"
          , name = "Invisibility"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "conceal_persist", name = "Persistent invisibility (regardless of actions)", description = "Normally ends if subject attacks; this removes that restriction", dcModifier = 4, kind = SeedToggle, maxQuantity = Just 1 }
              ]
          }
        , { id = "conceal_displacement"
          , name = "Displacement"
          , baseDCOverride = Nothing
          , factors = []
          }
        ]
    , universalFactors =
        [ { id = "conceal_block_divination", name = "Block divination / reveal-seed spells", description = "Opposed caster level check determines which spell works", dcModifier = 6, kind = SeedToggle, maxQuantity = Just 1 }
        ]
    , choices = []
    }


conjure : Seed
conjure =
    { id = Conjure
    , name = "Conjure"
    , baseDC = 21
    , school = "Conjuration (Creation)"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "0 ft."
    , targetAreaEffect = "Unattended, nonmagical object of nonliving matter up to 20 cu. ft."
    , duration = "8 hours (simple objects last 24 hours)"
    , savingThrow = Nothing
    , spellResistance = False
    , description = "Creates a nonmagical, unattended object of nonliving matter up to 20 cu. ft. Matter can range from vegetable matter to mithral or adamantine. Complex items require an appropriate skill check. Can also be used with the life and fortify seeds to create an entirely new creature if made permanent."
    , modes =
        [ { id = "conjure_object"
          , name = "Simple Object Creation"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "conjure_vol", name = "Each additional cu. ft. of matter", description = "Above base 20 cu. ft.", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "conjure_creature"
          , name = "Creature Creation (with Life + Fortify)"
          , baseDCOverride = Nothing
          , factors = []
          }
        ]
    , universalFactors = []
    , choices = []
    }


contact : Seed
contact =
    { id = Contact
    , name = "Contact"
    , baseDC = 23
    , school = "Divination"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "See text"
    , targetAreaEffect = "One creature"
    , duration = "200 minutes"
    , savingThrow = Nothing
    , spellResistance = False
    , description = "Forges a telepathic bond with a familiar or currently-visible creature for two-way communication. The subject recognizes the caster if known. Alternatively, imbues an object or creature with a conditional message (Messenger mode, base DC 20)."
    , modes =
        [ { id = "contact_bond"
          , name = "Telepathic Bond"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "contact_extra_creature", name = "Each additional creature in bond", description = "Bond only among willing subjects (no save or SR)", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
              , { id = "contact_language", name = "Telepathic communication regardless of language", description = "", dcModifier = 4, kind = SeedToggle, maxQuantity = Just 1 }
              ]
          }
        , { id = "contact_messenger"
          , name = "Messenger"
          , baseDCOverride = Just 20   -- SRD states base DC 20 for this mode
          , factors = []
          }
        ]
    , universalFactors = []
    , choices = []
    }


delude : Seed
delude =
    { id = Delude
    , name = "Delude"
    , baseDC = 14
    , school = "Illusion (Figment)"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "12,000 ft."
    , targetAreaEffect = "Visual figment up to twenty 30-ft. cubes (S)"
    , duration = "Concentration + 20 hours"
    , savingThrow = Just { saveType = WillSave, effect = Negates, harmless = False }
    , spellResistance = False
    , description = "Creates a visual illusion of an object, creature, or force. The image can be moved by concentration. Disappears if struck unless the caster reacts appropriately."
    , modes = []
    , universalFactors =
        [ { id = "delude_sense", name = "Each additional sensory aspect", description = "Audible, olfactory, tactile, taste, or thermal (cannot deal damage)", dcModifier = 2, kind = SeedStackable, maxQuantity = Just 5 }
        , { id = "delude_extra_image", name = "Each additional image", description = "", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "delude_script", name = "Illusion follows a script (no concentration)", description = "Can include intelligible speech", dcModifier = 9, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "delude_area", name = "Make an area appear to be something other than it is", description = "", dcModifier = 4, kind = SeedToggle, maxQuantity = Just 1 }
        ]
    , choices = []
    }


destroy : Seed
destroy =
    { id = Destroy
    , name = "Destroy"
    , baseDC = 29
    , school = "Transmutation"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "12,000 ft."
    , targetAreaEffect = "One creature, or up to a 10-ft. cube of nonliving matter"
    , duration = "Instantaneous"
    , savingThrow = Just { saveType = FortSave, effect = Half, harmless = False }
    , spellResistance = True
    , description = "Deals 20d6 points of damage (no specific type). If reduced to –10 hp or less (or 0 hp for constructs/objects/undead), the target is utterly destroyed as if disintegrated. Affects magical matter, energy fields, and force effects automatically. Can destroy ward-seed spells with an opposed caster level check."
    , modes = []
    , universalFactors =
        [ { id = "destroy_damage", name = "Each additional 1d6 damage", description = "Above base 20d6", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
        ]
    , choices = []
    }


dispel : Seed
dispel =
    { id = Dispel
    , name = "Dispel"
    , baseDC = 19
    , school = "Abjuration"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "300 ft."
    , targetAreaEffect = "One creature, object, or spell"
    , duration = "Instantaneous"
    , savingThrow = Nothing
    , spellResistance = False
    , description = "Ends ongoing spells on a creature or object, suppresses magic item properties (1d4 rounds), or ends spell effects in an area. Makes a dispel check: 1d20 + 10 vs. DC 11 + target spell's caster level. Defeats all spells including epic ones and supernatural abilities. Automatic success against own spells."
    , modes = []
    , universalFactors =
        [ { id = "dispel_bonus", name = "Each +1 to dispel check", description = "Above base +10", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
        ]
    , choices = []
    }


energy : Seed
energy =
    { id = Energy
    , name = "Energy"
    , baseDC = 19
    , school = "Evocation"
    , descriptors = []   -- descriptor set by energy type choice at runtime
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "300 ft."
    , targetAreaEffect = "20-ft.-radius hemisphere burst"
    , duration = "Instantaneous"
    , savingThrow = Just { saveType = ReflexSave, effect = Half, harmless = False }
    , spellResistance = True
    , description = "Uses one chosen energy type (acid, cold, electricity, fire, or sonic). Choose a mode: Bolt (10d6 damage), Emanation (2d6/round in 10-ft. radius for 20 hours), Wall/Dome/Sphere (2d4 near / 1d4 far, 2d6+20 passing through), or Weather effects (base DC 25, two-mile radius)."
    , modes =
        [ { id = "energy_bolt"
          , name = "Bolt"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "energy_bolt_damage", name = "Each additional 1d6 damage", description = "Above base 10d6", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
              , { id = "energy_bolt_imbue", name = "Imbue another creature with bolt ability", description = "As a spell-like ability, at its option or on trigger", dcModifier = 25, kind = SeedToggle, maxQuantity = Just 1 }
              ]
          }
        , { id = "energy_emanation"
          , name = "Emanation"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "energy_em_damage", name = "Each additional 1d6 damage per round", description = "Above base 2d6/round", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "energy_wall"
          , name = "Wall / Dome / Sphere"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "energy_wall_damage", name = "Each additional 1d4 damage (wall proximity)", description = "Above base 2d4 near / 1d4 far; passage damage scales with proximity damage", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "energy_weather"
          , name = "Weather Effects"
          , baseDCOverride = Just 25
          , factors = []
          }
        ]
    , universalFactors = []
    , choices =
        [ { id = "energyType", label = "Energy Type", options = [ "acid", "cold", "electricity", "fire", "sonic" ], default = "fire" }
        ]
    }


foresee : Seed
foresee =
    { id = Foresee
    , name = "Foresee"
    , baseDC = 17
    , school = "Divination"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "Personal"
    , targetAreaEffect = "You"
    , duration = "Instantaneous or concentration"
    , savingThrow = Nothing
    , spellResistance = False
    , description = "Foretells the immediate future or answers specific questions. Choose a mode: Predict the Future (90% chance of meaningful reading for next 30 min; multiplies DC for each additional 30 min), Ask Questions (base DC 23; up to 10 one-word answers, 90% truthful), or Targeted Info (basic info about a creature or object)."
    , modes =
        [ { id = "foresee_predict"
          , name = "Predict the Future (30 min)"
          , baseDCOverride = Nothing
          -- NOTE: Each additional 30-min interval multiplies the *seed's effective DC* by ×2.
          -- Implemented in DC calc as: effectiveSeedDC = baseDC * (2 ^ quantity).
          -- The factor below carries dcModifier = 0; special handling in Calc.elm.
          , factors =
              [ { id = "foresee_interval", name = "Each additional 30-min interval", description = "Multiplies this seed's DC by ×2 per interval (special: not additive)", dcModifier = 0, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "foresee_questions"
          , name = "Ask Questions (10 questions)"
          , baseDCOverride = Just 23
          , factors = []
          }
        , { id = "foresee_info"
          , name = "Targeted Info"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "foresee_extra_info", name = "Each additional piece of info about target", description = "Level, class, alignment, special ability, or magic item ability", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        ]
    , universalFactors = []
    , choices = []
    }


fortify : Seed
fortify =
    { id = Fortify
    , name = "Fortify"
    , baseDC = 17
    , school = "Transmutation"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "Touch"
    , targetAreaEffect = "Creature touched"
    , duration = "20 hours; permanent for age adjustment"
    , savingThrow = Just { saveType = WillSave, effect = Negates, harmless = True }
    , spellResistance = True
    , description = "Grants a +1 enhancement bonus to one ability score, saving throw, spell resistance, natural armor, energy resistance (1), or 1 temporary hp. Modes: enhancement bonus (base 17), non-enhancement bonus (base 23), bonus to something target doesn't have (base 27), grant Spell Resistance 25 (base 27), damage reduction 1/magic, or extend age category."
    , modes =
        [ { id = "fortify_enhance"
          , name = "Enhancement Bonus"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "fortify_enhance_plus", name = "Each additional +1 (or 1 energy resist / 1 temp hp)", description = "Above base +1", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "fortify_nonenhance"
          , name = "Non-Enhancement Bonus"
          , baseDCOverride = Just 23
          , factors =
              [ { id = "fortify_other_plus", name = "Each additional +1 non-enhancement bonus", description = "", dcModifier = 6, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "fortify_new"
          , name = "Bonus to New Statistic (target doesn't have it)"
          , baseDCOverride = Just 27
          , factors =
              [ { id = "fortify_new_plus", name = "Each additional +1", description = "", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "fortify_sr"
          , name = "Grant Spell Resistance 25"
          , baseDCOverride = Just 27
          , factors =
              [ { id = "fortify_sr_plus", name = "Each +1 SR above 25", description = "", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
              , { id = "fortify_sr_minus", name = "Each –1 SR below 25", description = "", dcModifier = -2, kind = SeedStackable, maxQuantity = Nothing }
              , { id = "fortify_dr_epic", name = "Damage Reduction vs. epic", description = "+15 DC surcharge to make DR bypass epic", dcModifier = 15, kind = SeedToggle, maxQuantity = Just 1 }
              ]
          }
        , { id = "fortify_age"
          , name = "Expand Age Category"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "fortify_age_year", name = "Each +1 year to current age category", description = "Increments do not stack; they overlap", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        ]
    , universalFactors =
        [ { id = "fortify_dr", name = "Each +1 damage reduction", description = "Any mode: adds DR/magic", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
        ]
    , choices = []
    }


heal : Seed
heal =
    { id = Heal
    , name = "Heal"
    , baseDC = 25
    , school = "Conjuration (Healing)"
    , descriptors = []
    , components = [ V, S, DF ]
    , castingTime = "1 minute"
    , range = "Touch"
    , targetAreaEffect = "Creature touched"
    , duration = "Instantaneous"
    , savingThrow = Just { saveType = WillSave, effect = Negates, harmless = True }
    , spellResistance = True
    , description = "Channels positive energy to cure all diseases, blindness, deafness, hit point damage, and temporary ability damage. Neutralizes poisons, offsets feeblemindedness, cures mental disorders, and dispels magical penalties. Does not restore levels or Constitution from death. Requires 24 ranks in Knowledge (arcana/nature/religion). Harm mode: flushes negative energy (heals undead, damages living)."
    , modes =
        [ { id = "heal_heal"
          , name = "Heal"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "heal_drain", name = "Restore drained ability scores", description = "", dcModifier = 6, kind = SeedToggle, maxQuantity = Just 1 }
              , { id = "heal_neg_levels", name = "Dispel all negative levels", description = "", dcModifier = 2, kind = SeedToggle, maxQuantity = Just 1 }
              , { id = "heal_extra_week", name = "Each additional week to restore negative levels", description = "Above free 20-week window", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "heal_harm"
          , name = "Harm (requires 24 ranks Knowledge)"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "heal_neg_level_extra", name = "Each additional negative level bestowed", description = "", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
              , { id = "heal_neg_level_hour", name = "Each extra hour negative levels persist", description = "", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        ]
    , universalFactors = []
    , choices = []
    }


life : Seed
life =
    { id = Life
    , name = "Life"
    , baseDC = 27
    , school = "Conjuration (Healing)"
    , descriptors = []
    , components = [ V, S, DF ]
    , castingTime = "1 minute"
    , range = "Touch"
    , targetAreaEffect = "Dead creature touched"
    , duration = "Instantaneous"
    , savingThrow = Nothing
    , spellResistance = True
    , description = "Restores life and full hit points to any dead creature (dead up to 200 years, any condition of remains). Subject loses one level (or 1 Con if 1st level). Cannot revive those dead of old age. Give Life mode: grants actual life and humanlike sentience to inanimate objects, plants, or animals (requires Will save, DC 10 + target HD)."
    , modes =
        [ { id = "life_resurrect"
          , name = "Resurrection"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "life_extra_decade", name = "Each additional 10 years beyond 200", description = "Target can have been dead longer", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "life_give"
          , name = "Give Life (to object/plant/animal)"
          , baseDCOverride = Nothing
          , factors = []
          }
        ]
    , universalFactors = []
    , choices = []
    }


reflect : Seed
reflect =
    { id = Reflect
    , name = "Reflect"
    , baseDC = 27
    , school = "Abjuration"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "Personal"
    , targetAreaEffect = "You"
    , duration = "Until expended (up to 12 hours)"
    , savingThrow = Nothing
    , spellResistance = False
    , description = "Reflects one type of attack back on the attacker. Each seed use covers one attack type: spells, ranged attacks, or melee attacks. One successful reflection expends the protection. Choose a mode."
    , modes =
        [ { id = "reflect_spell"
          , name = "Spell Reflection"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "reflect_aoe", name = "Reflect AoE spell (not directly targeted)", description = "", dcModifier = 20, kind = SeedToggle, maxQuantity = Just 1 }
              , { id = "reflect_spell_level", name = "Each additional spell level reflected", description = "Base reflects up to 1st level; each +1 level costs +20 DC; epic spells count as 10th level", dcModifier = 20, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "reflect_ranged"
          , name = "Ranged Attack Reflection"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "reflect_ranged_extra", name = "Each additional ranged attack reflected", description = "Base: 5 attacks", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "reflect_melee"
          , name = "Melee Attack Reflection"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "reflect_melee_extra", name = "Each additional melee attack reflected", description = "Base: 5 attacks", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        ]
    , universalFactors = []
    , choices = []
    }


reveal : Seed
reveal =
    { id = Reveal
    , name = "Reveal"
    , baseDC = 19
    , school = "Divination"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "See text"
    , targetAreaEffect = "See text"
    , duration = "Concentration + 20 minutes"
    , savingThrow = Nothing
    , spellResistance = False
    , description = "See or hear at a distant location via an invisible sensor. Distance is not a factor, but the locale must be known. Can also pierce illusions (base DC 25, 120-ft. true sight) or comprehend/speak languages."
    , modes =
        [ { id = "reveal_sensor"
          , name = "Sensor"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "reveal_hear", name = "Both see and hear through sensor", description = "", dcModifier = 2, kind = SeedToggle, maxQuantity = Just 1 }
              , { id = "reveal_mobile", name = "Mobile sensor (speed 30 ft.)", description = "", dcModifier = 2, kind = SeedToggle, maxQuantity = Just 1 }
              , { id = "reveal_plane", name = "Sensor on a different plane", description = "", dcModifier = 8, kind = SeedToggle, maxQuantity = Just 1 }
              , { id = "reveal_magic_senses", name = "Magically enhanced senses through sensor", description = "", dcModifier = 4, kind = SeedToggle, maxQuantity = Just 1 }
              , { id = "reveal_cast_through", name = "Cast touch-or-greater spells through sensor", description = "Must maintain line of effect to sensor", dcModifier = 6, kind = SeedToggle, maxQuantity = Just 1 }
              , { id = "reveal_no_loe", name = "No line of effect required for spells through sensor", description = "Multiplies DC by ×10", dcModifier = 0, kind = SeedToggle, maxQuantity = Just 1 }
              -- NOTE: "no_loe" is a ×10 multiplier on this seed's DC. Handled as special case in Calc.elm.
              ]
          }
        , { id = "reveal_truesight"
          , name = "Pierce Illusions (True Sight, 120 ft.)"
          , baseDCOverride = Just 25
          , factors = []
          }
        , { id = "reveal_language"
          , name = "Languages"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "reveal_both_lang", name = "Both comprehend and speak a language", description = "", dcModifier = 4, kind = SeedToggle, maxQuantity = Just 1 }
              ]
          }
        ]
    , universalFactors = []
    , choices = []
    }


slay : Seed
slay =
    { id = Slay
    , name = "Slay"
    , baseDC = 25
    , school = "Necromancy"
    , descriptors = [ "Death" ]
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "300 ft."
    , targetAreaEffect = "One living creature of up to 80 HD"
    , duration = "Instantaneous"
    , savingThrow = Just { saveType = FortSave, effect = Partial, harmless = False }
    , spellResistance = True
    , description = "Kills a living creature of up to 80 HD (Fort save or die; on successful save, takes 3d6+20 damage instead). Alternatively, bestows 2d4 negative levels (Enervate mode). If negative levels equal or exceed HD, the target dies."
    , modes =
        [ { id = "slay_kill"
          , name = "Kill"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "slay_hd", name = "Each additional 80 HD affected", description = "Or each additional creature affected", dcModifier = 8, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "slay_enervate"
          , name = "Enervate (negative levels)"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "slay_neg_level", name = "Each additional 1d4 negative levels", description = "Base: 2d4 negative levels", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        ]
    , universalFactors = []
    , choices = []
    }


summon : Seed
summon =
    { id = Summon
    , name = "Summon"
    , baseDC = 14
    , school = "Conjuration (Summoning)"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "75 ft."
    , targetAreaEffect = "One summoned creature"
    , duration = "20 rounds (D)"
    , savingThrow = Just { saveType = WillSave, effect = Negates, harmless = False }
    , spellResistance = True
    , description = "Summons an outsider of CR 2 or less that attacks the caster's opponents. For each +1 CR, add +2 DC. Summoning multiple creatures of the same CR multiplies the total DC by the number summoned. Can summon non-outsider types (+10 DC) or a unique named individual (+60 DC)."
    , modes =
        [ { id = "summon_generic"
          , name = "Summon Generic Creature"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "summon_cr", name = "Each +1 CR above CR 1", description = "", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
              , { id = "summon_nonoutsider", name = "Summon a non-outsider creature type", description = "+10 DC flat surcharge", dcModifier = 10, kind = SeedToggle, maxQuantity = Just 1 }
              -- Multiplying DC for multiple creatures is handled via a note; implement as a stackable that triggers multiply logic.
              ]
          }
        , { id = "summon_unique"
          , name = "Summon Unique Individual"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "summon_unique_dc", name = "Summon specific named individual", description = "+60 DC flat surcharge", dcModifier = 60, kind = SeedToggle, maxQuantity = Just 1 }
              ]
          }
        ]
    , universalFactors = []
    , choices = []
    }


transform : Seed
transform =
    { id = Transform
    , name = "Transform"
    , baseDC = 21
    , school = "Transmutation"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "300 ft."
    , targetAreaEffect = "One creature"
    , duration = "20 hours"
    , savingThrow = Just { saveType = FortSave, effect = Negates, harmless = False }
    , spellResistance = True
    , description = "Changes the subject into another form (Diminutive to one size larger than normal). Transformed creature retains mental abilities and scores but gains physical attributes of the new form. Equipment melds or remains (caster's choice)."
    , modes = []
    , universalFactors =
        [ { id = "transform_type", name = "Change creature type", description = "", dcModifier = 5, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "transform_size", name = "Each additional size increment change", description = "Beyond one size larger than normal", dcModifier = 6, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "transform_inanimate", name = "Nonmagical inanimate ↔ creature", description = "", dcModifier = 10, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "transform_hardness", name = "Each 2 points of hardness of target object", description = "", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "transform_incorporeal", name = "Transform to/from incorporeal or gaseous form", description = "+10 each direction", dcModifier = 10, kind = SeedStackable, maxQuantity = Just 2 }
        , { id = "transform_specific", name = "Transform into specific individual (with memories)", description = "", dcModifier = 25, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "transform_ability", name = "Each extraordinary or supernatural ability granted", description = "", dcModifier = 10, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "transform_hd", name = "Each HD of assumed form above 15", description = "", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
        ]
    , choices = []
    }


transport : Seed
transport =
    { id = Transport
    , name = "Transport"
    , baseDC = 27
    , school = "Conjuration"
    , descriptors = [ "Teleportation" ]
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "Touch"
    , targetAreaEffect = "You and touched willing creatures up to 1,000 lb."
    , duration = "Instantaneous, or 5 rounds for temporal"
    , savingThrow = Nothing
    , spellResistance = False
    , description = "Instantly transports the caster to a designated destination. Choose mode: Spatial (standard teleport), Temporal (freeze/accelerate time for 5 rounds), or Temporal Lite (haste/slow a subject for 20 rounds, –4 DC)."
    , modes =
        [ { id = "transport_spatial"
          , name = "Spatial (Teleport)"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "transport_interplanar", name = "Interplanar travel", description = "", dcModifier = 4, kind = SeedToggle, maxQuantity = Just 1 }
              , { id = "transport_weight", name = "Each additional 50 lbs. beyond 1,000", description = "", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
              , { id = "transport_medium", name = "Use transport medium other than Astral Plane", description = "", dcModifier = 2, kind = SeedToggle, maxQuantity = Just 1 }
              , { id = "transport_unwilling", name = "Transport unwilling creatures", description = "", dcModifier = 4, kind = SeedToggle, maxQuantity = Just 1 }
              ]
          }
        , { id = "transport_temporal"
          , name = "Temporal (time stream)"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "transport_temporal_dc", name = "Temporal transport surcharge", description = "+8 DC to enter a different time stream (freeze or accelerate)", dcModifier = 8, kind = SeedToggle, maxQuantity = Just 1 }
              ]
          }
        , { id = "transport_temporal_lite"
          , name = "Temporal Lite (haste/slow 20 rounds)"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "transport_lite_dc", name = "Temporal lite discount", description = "–4 DC for haste/slow effect only", dcModifier = -4, kind = SeedToggle, maxQuantity = Just 1 }
              ]
          }
        ]
    , universalFactors = []
    , choices = []
    }


ward : Seed
ward =
    { id = Ward
    , name = "Ward"
    , baseDC = 14
    , school = "Abjuration"
    , descriptors = []
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "Touch"
    , targetAreaEffect = "Touched creature or object up to 2,000 lb.; or 10-ft.-radius emanation"
    , duration = "200 minutes (D)"
    , savingThrow = Nothing
    , spellResistance = True
    , description = "Protects a creature, object, or area. Choose a mode: Damage Ward (absorbs 5 points of bludgeoning/piercing/slashing damage per round), Energy Ward (absorbs 5 points of one energy type per round), Creature Ward (prevents bodily contact from one creature type), or Magic Ward (10-ft. sphere blocking spells of up to 1st level)."
    , modes =
        [ { id = "ward_damage"
          , name = "Damage Ward (B/P/S)"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "ward_all_three", name = "Ward all three damage types (B, P, and S)", description = "Base covers two; +4 DC for all three", dcModifier = 4, kind = SeedToggle, maxQuantity = Just 1 }
              , { id = "ward_dmg_pts", name = "Each additional point of damage absorbed per round", description = "Above base 5", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "ward_energy"
          , name = "Energy Ward"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "ward_energy_pts", name = "Each additional point of energy absorbed per round", description = "Above base 5", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        , { id = "ward_creature"
          , name = "Creature Ward"
          , baseDCOverride = Nothing
          , factors = []
          }
        , { id = "ward_magic"
          , name = "Magic Ward (spell level exclusion)"
          , baseDCOverride = Nothing
          , factors =
              [ { id = "ward_magic_level", name = "Each additional spell level excluded", description = "Above 1st level; +20 DC per level", dcModifier = 20, kind = SeedStackable, maxQuantity = Nothing }
              , { id = "ward_specific_spell", name = "Each specific spell nullified (per spell level above 1st)", description = "+2 DC per spell level above 1st", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
              ]
          }
        ]
    , universalFactors = []
    , choices =
        [ { id = "wardEnergyType", label = "Energy Type (Energy Ward)", options = [ "acid", "cold", "electricity", "fire", "sonic" ], default = "fire" }
        , { id = "wardCreatureType", label = "Creature Type (Creature Ward)", options = [ "aberrations", "animals", "constructs", "dragons", "elementals", "fey", "giants", "humanoids", "magical beasts", "monstrous humanoids", "oozes", "outsiders", "plants", "undead", "vermin" ], default = "undead" }
        ]
    }
