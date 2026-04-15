module Seeds exposing (allSeeds, getSeed)

import Dict exposing (Dict)
import Types exposing (..)


-- ─── Lookup helpers ──────────────────────────────────────────────────────────

allSeeds : List Seed
allSeeds =
    [ afflict
    , animate
    , animateDead
    , armor
    , banish
    , compel
    , conceal
    , conjure
    , contact
    , delude
    , destroy
    , dispel
    , energy
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
