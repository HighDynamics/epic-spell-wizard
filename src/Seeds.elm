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
    , foresee
    , fortify
    , heal
    , life
    , reflect
    , reveal
    , slay
    , summon
    , transform
    , transport
    , ward
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
    , description = """Afflicts the target with a –2 morale penalty on attack rolls, checks, and saving throws. For each additional –1 penalty assessed on either the target's attack rolls, checks, or saving throws, increase the Spellcraft DC by +2. A character may also develop a spell with this seed that afflicts the target with a –1 penalty on caster level checks, a –1 penalty to an ability score, a –1 penalty to Spell Resistance, or a –1 penalty to some other aspect of the target. For each additional –1 penalty assessed in one of the above categories, increase the Spellcraft DC by +4. This seed can afflict a character's ability scores to the point where they reach 0, except for Constitution where 1 is the minimum. If a factor is applied to increase the duration of this seed, ability score penalties instead become temporary ability damage. If a factor is applied to make the duration permanent, any ability score penalties become permanent ability drain. Finally, by increasing the Spellcraft DC by +2, one of the target's senses can be afflicted: sight, smell, hearing, taste, touch, or a special sense the target possesses. If the target fails its saving throw, the sense selected doesn't function for the spell's duration, with all attendant penalties that apply for losing the specified sense."""
    , modes = []
    , universalFactors =
        [ { id = "afflict_rolls", name = "Additional –1 to rolls/checks/saves", description = "Each additional –1 morale penalty beyond base –2", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "afflict_ability_str", name = "–1 to Strength", description = "Each –1 penalty to Strength score", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "afflict_ability_dex", name = "–1 to Dexterity", description = "Each –1 penalty to Dexterity score", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "afflict_ability_con", name = "–1 to Constitution", description = "Each –1 penalty to Constitution score", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "afflict_ability_int", name = "–1 to Intelligence", description = "Each –1 penalty to Intelligence score", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "afflict_ability_wis", name = "–1 to Wisdom", description = "Each –1 penalty to Wisdom score", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "afflict_ability_cha", name = "–1 to Charisma", description = "Each –1 penalty to Charisma score", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "afflict_cl", name = "–1 to caster level checks", description = "Each –1 penalty to caster level checks", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "afflict_sr", name = "–1 to spell resistance", description = "Each –1 penalty to spell resistance", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "afflict_other", name = "–1 to other aspect", description = "Each –1 penalty to some other aspect of the target", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
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
    , description = """This seed can imbue inanimate objects with mobility and a semblance of life (not actual life). The animated object attacks whomever or whatever the caster initially designates. The animated object can be of any nonmagical material. The caster can also animate part of a larger mass of raw matter, such as a volume of water in the ocean, part of a stony wall, or the earth itself, as long as the volume of material does not exceed 20 cubic feet. For each additional 10 cubic feet of matter animated, increase the Spellcraft DC by +1, up to 1,000 cubic feet. For each additional 100 cubic feet of matter animated after the first 1,000 cubic feet, increase the Spellcraft DC by +1. For each additional Hit Die granted to an animated object of a given size, increase the Spellcraft DC by +2. To animate attended objects (objects carried or worn by another creature), increase the Spellcraft DC by +10."""
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
    , description = """The caster can turn the bones or bodies of dead creatures into undead that follow his or her spoken commands. The undead can follow the caster, or they can remain in an area and attack any creature (or a specific type of creature) entering the place. The undead remain animated until they are destroyed. (A destroyed undead can't be animated again.) Intelligent undead can follow more sophisticated commands. The animate dead seed allows a character to create 20 HD of undead. For each additional 1 HD of undead created, increase the Spellcraft DC by +1. The undead created remain under the caster's control indefinitely. A caster can naturally control 1 HD per caster level of undead creatures he or she has personally created, regardless of the method used. If the caster exceeds this number, newly created creatures fall under his or her control, and excess undead from previous castings become uncontrolled (the caster chooses which creatures are released). If the caster is a cleric, any undead he or she commands through his or her ability to command or rebuke undead do not count toward the limit. For each additional 2 HD of undead to be controlled, increase the Spellcraft DC by +1. Only undead in excess of 20 HD created with this seed can be controlled using this DC adjustment. To both create and control more than 20 HD of undead, increase the Spellcraft DC by +3 per additional 2 HD of undead.

Type of Undead: All types of undead can be created with the animate dead seed, although creating more powerful undead increases the Spellcraft DC of the epic spell, according to the table below. The GM must set the Spellcraft DC for undead not included on the table, using similar undead as a basis for comparison."""
    , modes = []
    , universalFactors =
        [ { id = "adead_extra_hd_create", name = "Each additional 1 HD of undead created", description = "Above base 20 HD", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
        , { id = "adead_extra_hd_control", name = "Each additional 2 HD to control", description = "Control undead beyond free limit (above 20 HD created)", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }

        -- Undead type modifiers (applied as a single toggle per type):
        , { id = "adead_skeleton", name = "Undead type: Skeleton", description = "DC modifier for skeleton type", dcModifier = -12, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_zombie", name = "Undead type: Zombie", description = "DC modifier for zombie type", dcModifier = -12, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_ghoul", name = "Undead type: Ghoul", description = "DC modifier for ghoul type", dcModifier = -10, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_shadow", name = "Undead type: Shadow", description = "DC modifier for shadow type", dcModifier = -8, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_ghast", name = "Undead type: Ghast", description = "DC modifier for ghast type", dcModifier = -6, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_wight", name = "Undead type: Wight", description = "DC modifier for wight type", dcModifier = -4, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_wraith", name = "Undead type: Wraith", description = "DC modifier for wraith type", dcModifier = -2, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_mummy", name = "Undead type: Mummy", description = "DC modifier for mummy type", dcModifier = 0, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_spectre", name = "Undead type: Spectre", description = "DC modifier for spectre type", dcModifier = 2, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_mohrg", name = "Undead type: Mohrg", description = "DC modifier for mohrg type", dcModifier = 4, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_vampire", name = "Undead type: Vampire", description = "DC modifier for vampire type", dcModifier = 6, kind = SeedToggle, maxQuantity = Just 1 }
        , { id = "adead_ghost", name = "Undead type: Ghost", description = "DC modifier for ghost type", dcModifier = 8, kind = SeedToggle, maxQuantity = Just 1 }
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
    , description = """This seed grants a creature additional armor, providing a +4 bonus to Armor Class. The bonus is either an armor bonus or a natural armor bonus, whichever the caster selects. Unlike mundane armor, the armor seed provides an intangible protection that entails no armor check penalty, arcane spell failure chance, or speed reduction. Incorporeal creatures can't bypass the armor seed the way they can ignore normal armor. For each additional point of Armor Class bonus, increase the Spellcraft DC by +2. The caster can also grant a creature a +1 bonus to Armor Class using a different bonus type, such as deflection, divine, or insight. For each additional point of bonus to Armor Class of one of these types, increase the Spellcraft DC by +10."""
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
    , description = """This seed forces extraplanar creatures out of the caster's home plane. The caster can banish up to 14 HD of extraplanar creatures. For each additional 2 HD of extraplanar creatures banished, increase the Spellcraft DC by +1. To specify a type or subtype of creature other than outsider to be banished, increase the Spellcraft DC by +20."""
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
    , description = """This seed compels a target to follow a course of activity. At the basic level of effect, a spell using the compel seed must be worded in such a manner as to make the activity sound reasonable. Asking the creature to do an obviously harmful act automatically negates the effect (unless the Spellcraft DC has been increased to avoid this limitation; see below). To compel a creature to follow an outright unreasonable course of action, increase the Spellcraft DC by +10. The compelled course of activity can continue for the entire duration. If the compelled activity can be completed in a shorter time, the spell ends when the subject finishes what he or she was asked to do. The caster can instead specify conditions that will trigger a special activity during the duration. If the condition is not met before the spell using this seed expires, the activity is not performed."""
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
    , description = """This seed can conceal a creature or object touched from sight, even from darkvision. If the subject is a creature carrying gear, the gear vanishes too, rendering the creature invisible. A spell using the conceal seed ends if the subject attacks any creature. Actions directed at unattended objects do not break the spell, and causing harm indirectly is not an attack. To create invisibility that lasts regardless of the actions of the subject, increase the Spellcraft DC by +4. Alternatively, this seed can conceal the exact location of the subject so that it appears to be about 2 feet away from its true location; this increases the Spellcraft DC by +2. The subject benefits from a 50% miss chance as if it had total concealment. However, unlike actual total concealment, this displacement effect does not prevent enemies from targeting him or her normally. The conceal seed can also be used to block divination spells, spell-like effects, and epic spells developed using the reveal seed; this increases the Spellcraft DC by +6. In all cases where divination magic of any level, including epic level, is employed against the subject of a spell using the conceal seed for this purpose, an opposed caster level check determines which spell works."""
    , modes =
        [ { id = "conceal_invisibility"
          , name = "Invisibility"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "conceal_persist", name = "Persistent invisibility (regardless of actions)", description = "Normally ends if subject attacks; this removes that restriction", dcModifier = 4, kind = SeedToggle, maxQuantity = Just 1 }
                ]
          }
        , { id = "conceal_displacement"
          , name = "Displacement"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
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
    , description = """This seed creates a nonmagical, unattended object of nonliving matter of up to 20 cubic feet in volume. The caster must succeed at an appropriate skill check to make a complex item. The seed can create matter ranging in hardness and rarity from vegetable matter all the way up to mithral and even adamantine. Simple objects have a natural duration of 24 hours. For each additional cubic foot of matter created, increase the Spellcraft DC by +2. Attempting to use any created object as a material component or a resource during epic spell development causes the spell to fail and the object to disappear.

The Conjure seed can be used in conjunction with the life and fortify seeds for an epic spell that creates an entirely new creature, if made permanent. To give a creature spell-like abilities, apply other epic seeds to the epic spell that replicate the desired ability. To give the creature a supernatural or extraordinary ability rather than a spell-like ability, double the cost of the relevant seed. Remember that two doublings equals a tripling, and so forth. To give a creature Hit Dice, use the fortify seed. Each 5 hit points granted to the creature gives it an additional 1 HD. Once successfully created, the new creature will breed true."""
    , modes =
        [ { id = "conjure_object"
          , name = "Simple Object Creation"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "conjure_vol", name = "Each additional cu. ft. of matter", description = "Above base 20 cu. ft.", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "conjure_creature"
          , name = "Creature Creation (with Life + Fortify)"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
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
    , description = """This seed forges a telepathic bond with a particular creature with which the caster is familiar (or one that the caster can currently see directly or through magical means) and can converse back and forth. The subject recognizes the caster if it knows him or her. It can answer in like manner immediately, though it does not have to. The caster can forge a communal bond among more than two creatures. For each additional creature contacted, increase the Spellcraft DC by +1. The bond can be established only among willing subjects, which therefore receive no saving throw or Spell Resistance. For telepathic communication through the bond regardless of language, increase the Spellcraft DC by +4. No special influence is established as a result of the bond, only the power to communicate at a distance.

At the base Spellcraft DC of 20, a caster can also use the contact seed to imbue an object (or creature) with a message he or she prepares that appears as written text for the spell's duration or is spoken aloud in a language the caster knows. The spoken message can be of any length, but the length of written text is limited to what can be contained (as text of a readable size) on the surface of the target. The message is delivered when specific conditions are fulfilled according to the caster's desire when the spell is cast."""
    , modes =
        [ { id = "contact_bond"
          , name = "Telepathic Bond"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "contact_extra_creature", name = "Each additional creature in bond", description = "Bond only among willing subjects (no save or SR)", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
                , { id = "contact_language", name = "Telepathic communication regardless of language", description = "", dcModifier = 4, kind = SeedToggle, maxQuantity = Just 1 }
                ]
          }
        , { id = "contact_messenger"
          , name = "Messenger"
          , baseDCOverride = Just 20
          , durationOverride = Nothing -- SRD states base DC 20 for this mode
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
    , description = "A spell developed with the delude seed creates the visual illusion of an object, creature, or force, as visualized by the caster. The caster can move the image within the limits of the size of the effect by concentrating (the image is otherwise stationary). The image disappears when struck by an opponent unless the caster causes the illusion to react appropriately. For an illusion that includes audible, olfactory, tactile, taste, and thermal aspects, increase the Spellcraft DC by +2 per extra aspect. Even realistic tactile and thermal illusions can't deal damage, however. For each additional image to be created, increase the Spellcraft DC by +1. For an illusion that follows a script determined by the caster, increase the Spellcraft DC by +9. The figment follows the script without the caster having to concentrate on it. The illusion can include intelligible speech if desired. For an illusion that makes any area appear to be something other than it is, increase the Spellcraft DC by +4. Additional components, such as sounds, can be added as noted above. Concealing creatures requires additional spell development using this or other seeds."
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
    , description = "This seed deals 20d6 points of damage to the target. The damage is of no particular type or energy. For each additional 1d6 points of damage dealt, increase the Spellcraft DC by +2. If the target is reduced to -10 hit points or less (or a construct, object, or undead is reduced to 0 hit points), it is utterly destroyed as if disintegrated, leaving behind only a trace of fine dust. Up to a 10-foot cube of nonliving matter is affected, so a spell using the destroy seed destroys only part of any very large object or structure targeted. The destroy seed affects even magical matter, energy fields, and force effects that are normally only affected by the disintegrate spell. Such effects are automatically destroyed. Epic spells using the ward seed may also be destroyed, though the caster must succeed at an opposed caster level check against the other spellcaster to bring down a ward spell."
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
    , description = "This seed can end ongoing spells that have been cast on a creature or object, temporarily suppress the magical abilities of a magic item, or end ongoing spells (or at least their effects) within an area. A dispelled spell ends as if its duration had expired. The dispel seed can defeat all spells, even those not normally subject to dispel magic. The dispel seed can dispel (but not counter) the ongoing effects of supernatural abilities as well as spells, and it affects spell-like effects just as it affects spells. One creature, object, or spell is the target of the dispel seed. The caster makes a dispel check against the spell or against each ongoing spell currently in effect on the object or creature. A dispel check is 1d20 + 10 against a DC of 11 + the target spell's caster level. For each additional +1 on the dispel check, increase the Spellcraft DC by +1. If targeting an object or creature that is the effect of an ongoing spell, make a dispel check to end the spell that affects the object or creature. If the object targeted is a magic item, make a dispel check against the item's caster level. If succeessful, all the item's magical properties are suppressed for 1d4 rounds, after which the item recovers on its own. A suppressed item becomes nonmagical for the duration of the effect. An interdimensional interface is temporarily closed. A magic item's physical properties are unchanged. Any creature, object, or spell is potentially subject to the dispel seed, even the spells of gods and the abilities of artifacts. A character automatically succeeds on the dispel check against any spell that he or she cast him or her self."
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
    , descriptors = [] -- descriptor set by energy type choice at runtime
    , components = [ V, S ]
    , castingTime = "1 minute"
    , range = "300 ft."
    , targetAreaEffect = "20-ft.-radius hemisphere burst"
    , duration = "Instantaneous"
    , savingThrow = Just { saveType = ReflexSave, effect = Half, harmless = False }
    , spellResistance = True
    , description = """This seed uses whichever one of five energy types the caster chooses: acid, cold, electricity, fire, or sonic. The caster can cast the energy forth as a bolt, imbue an object with the energy, or create a freestanding manifestation of the energy. If the spell developed using the energy seed releases a bolt, that bolt instantaneously deals 10d6 points of damage of the appropriate energy type, and all in the bolt's area must make a Reflex save for half damage. For each additional 1d6 points of damage dealt, increase the Spellcraft DC by +2. The bolt begins at the caster’s fingertips. To imbue another creature with the ability to use an energy bolt as a spell-like ability at its option or when a particular condition is met, increase the Spellcraft DC by +25. The caster can also cause a creature or object to emanate the specific energy type out to a radius of 10 feet for 20 hours. The emanated energy deals 2d6 points of energy damage per round against unprotected creatures (the target creature is susceptible if not separately warded or otherwise resistant to the energy). For each additional 1d6 points of damage emanated, increase the Spellcraft DC by +2. The caster may also create a wall, half-circle, circle, dome, or sphere of the desired energy that emanates the energy for up to 20 hours. One side of the wall, selected by the caster, sends forth waves of energy, dealing 2d4 points of energy damage to creatures within 10 feet and 1d4 points of energy damage to those past 10 feet but within 20 feet. The wall deals this damage when it appears and in each round that a creature enters or remains in the area. In addition, the wall deals 2d6+20 points of energy damage to any creature passing through it. The wall deals double damage to undead creatures. For each additional 1d4 points of damage, increase the Spellcraft DC by +2.

The caster can also use the energy seed to create a spell that carefully releases and balances the emanation of cold, electricity, and fire, creating specific weather effects for a period of 20 hours. Using the energy seed this way has a base Spellcraft DC of 25. The area extends to a two-mile-radius centered on the caster. Once the spell is cast, the weather takes 10 minutes to manifest. Ordinarily, a caster can't directly target a creature or object, though indirect effects are possible. This seed can create cold snaps, heat waves, thunderstorms, fogs, blizzards—even a tornado that moves randomly in the affected area. Creating targeted damaging effects requires an additional use of the energy seed."""
    , modes =
        [ { id = "energy_bolt"
          , name = "Bolt"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "energy_bolt_damage", name = "Each additional 1d6 damage", description = "Above base 10d6", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
                , { id = "energy_bolt_imbue", name = "Imbue another creature with bolt ability", description = "As a spell-like ability, at its option or on trigger", dcModifier = 25, kind = SeedToggle, maxQuantity = Just 1 }
                ]
          }
        , { id = "energy_emanation"
          , name = "Emanation"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "energy_em_damage", name = "Each additional 1d6 damage per round", description = "Above base 2d6/round", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "energy_wall"
          , name = "Wall / Dome / Sphere"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "energy_wall_damage", name = "Each additional 1d4 damage (wall proximity)", description = "Above base 2d4 near / 1d4 far; passage damage scales with proximity damage", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "energy_weather"
          , name = "Weather Effects"
          , baseDCOverride = Just 25
          , durationOverride = Nothing
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
    , description = "The caster can foretell the immediate future, or gain information about specific questions. He or she is 90% likely to receive a meaningful reading of the future of the next 30 minutes. If successful, the caster knows if a particular action will bring good results, bad results, or no result. For each additional 30 minutes into the future, multiply the Spellcraft DC by x2. For better results, the caster can pose up to ten specific questions (one per round while he or she concentrates) to unknown powers of other planes, but the base Spellcraft DC for such an attempt is 23. The answers return in a language the caster understands, but use only one-word replies: “yes,” “no,” “maybe,” “never,” “irrelevant,” or some other one-word answer. Unlike 0- to 9th-level spells of similar type, all questions answered are 90% likely to be answered truthfully. However, a specific spell using the foresee seed can only be cast once every five weeks. The foresee seed is also useful for epic spells requiring specific information before functioning, such as spells using the reveal and transport seeds. The foresee seed can also be used to gain one basic piece of information about a living target: level, class, alignment, or some special ability (or one of an object's magical abilities, if any). For each additional piece of information revealed, increase the Spellcraft DC by +2."
    , modes =
        [ { id = "foresee_predict"
          , name = "Predict the Future (30 min)"
          , baseDCOverride = Nothing
          , durationOverride = Nothing

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
          , durationOverride = Nothing
          , factors = []
          }
        , { id = "foresee_info"
          , name = "Targeted Info"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
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
    , duration = "20 hours"
    , savingThrow = Just { saveType = WillSave, effect = Negates, harmless = True }
    , spellResistance = True
    , description = """Spells using the fortify seed grant a +1 enhancement bonus to whichever one of the following the caster chooses:

Any one ability score.
Any one kind of saving throw.
Spell resistance.
Natural armor.
The fortify seed can also grant energy resistance 1 for one energy type or 1 temporary hit point. For each additional +1 bonus, point of energy resistance, or hit point, increase the Spellcraft DC by +2.

The fortify seed has a base Spellcraft DC of 23 if it grants a +1 bonus of a type other than enhancement. For each additional +1 bonus of a type other than enhancement, increase the Spellcraft DC by +6. If the caster applies a factor to make the duration permanent, the bonus must be an inherent bonus, and the maximum inherent bonus allowed is +5.

The fortify seed has a base Spellcraft DC of 27 if it grants a creature a +1 bonus to an ability score or other statistic it does not possess. For each additional +1 bonus, increase the Spellcraft DC by +4. If a spell with the fortify seed grants an inanimate object an ability score it would not normally possess (such as Intelligence), the spell must also incorporate the life seed.

Granting Spell Resistance to a creature that doesn't already have it is a special case; the base Spellcraft DC of 27 grants Spell Resistance 25, and each additional point of Spell Resistance increases the Spellcraft DC by +4 (each -1 to Spell Resistance reduces the Spellcraft DC by -2).

The fortify seed can also grant damage reduction 1/magic. For each additional point of damage reduction, increase the Spellcraft DC by +2. To increase the damage reduction value to epic, increase the Spellcraft DC by +15.

A special use of the fortify seed grants the target a permanent +1 year to its current age category. For each additional +1 year added to the creature's current age category, increase the Spellcraft DC by +2. Incremental adjustments to a creature's maximum age do not stack; they overlap. When a spell increases a creature's current age category, all higher age categories are also adjusted accordingly."""
    , modes =
        [ { id = "fortify_enhance"
          , name = "Enhancement Bonus"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "fortify_enhance_plus", name = "Each additional +1 (or 1 energy resist / 1 temp hp)", description = "Above base +1", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "fortify_nonenhance"
          , name = "Non-Enhancement Bonus"
          , baseDCOverride = Just 23
          , durationOverride = Nothing
          , factors =
                [ { id = "fortify_other_plus", name = "Each additional +1 non-enhancement bonus", description = "", dcModifier = 6, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "fortify_new"
          , name = "Bonus to New Statistic (target doesn't have it)"
          , baseDCOverride = Just 27
          , durationOverride = Nothing
          , factors =
                [ { id = "fortify_new_plus", name = "Each additional +1", description = "", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "fortify_sr"
          , name = "Grant Spell Resistance 25"
          , baseDCOverride = Just 27
          , durationOverride = Nothing
          , factors =
                [ { id = "fortify_sr_plus", name = "Each +1 SR above 25", description = "", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
                , { id = "fortify_sr_minus", name = "Each –1 SR below 25", description = "", dcModifier = -2, kind = SeedStackable, maxQuantity = Nothing }
                , { id = "fortify_dr_epic", name = "Damage Reduction vs. epic", description = "+15 DC surcharge to make DR bypass epic", dcModifier = 15, kind = SeedToggle, maxQuantity = Just 1 }
                ]
          }
        , { id = "fortify_age"
          , name = "Expand Age Category"
          , baseDCOverride = Nothing
          , durationOverride = Just "Permanent"
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
    , description = """Spells developed with the heal seed channel positive energy into a creature to wipe away disease and injury. Such a spell completely cures all diseases, blindness, deafness, hit point damage, and temporary ability damage. To restore permanently drained ability score points, increase the Spellcraft DC by +6. The heal seed neutralizes poisons in the subject's system so that no additional damage or effects are suffered. It offsets feeblemindedness and cures mental disorders caused by spells or injury to the brain. It dispels all magical effects penalizing the character's abilities, including effects caused by spells, even epic spells developed with the afflict seed. Only a single application of the spell is needed to simultaneously achieve all these effects. This seed does not restore levels or Constitution points lost due to death.

To dispel all negative levels afflicting the target, increase the Spellcraft DC by +2. This reverses level drains by a force or creature. The drained levels are restored only if the creature lost the levels within the last 20 weeks. For each additional week since the levels were drained, increase the Spellcraft DC by +2.

Against undead, the influx of positive energy causes the loss of all but 1d4 hit points if the undead fails a Fortitude saving throw.

An epic caster with 24 ranks in Knowledge (arcana), Knowledge (nature), or Knowledge (religion) can cast a spell developed with a special version of the heal seed that flushes negative energy into the subject, healing undead completely but causing the loss of all but 1d4 hit points in living creatures if they fail a Fortitude saving throw. Alternatively, a living target that fails its Fortitude saving throw could gain four negative levels for the next 8 hours. For each additional negative level bestowed, increase the Spellcraft DC by +4, and for each extra hour the negative levels persist, increase the Spellcraft DC by +2. If the subject has at least as many negative levels as Hit Dice, it dies. If the subject survives and the negative levels persist for 24 hours or longer, the subject must make another Fortitude saving throw, or the negative levels are converted to actual level loss.

"""
    , modes =
        [ { id = "heal_heal"
          , name = "Heal"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "heal_drain", name = "Restore drained ability scores", description = "", dcModifier = 6, kind = SeedToggle, maxQuantity = Just 1 }
                , { id = "heal_neg_levels", name = "Dispel all negative levels", description = "", dcModifier = 2, kind = SeedToggle, maxQuantity = Just 1 }
                , { id = "heal_extra_week", name = "Each additional week to restore negative levels", description = "Above free 20-week window", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "heal_harm"
          , name = "Harm (requires 24 ranks Knowledge)"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
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
    , description = """A spell developed with the life seed will restore life and complete vigor to any deceased creature. The condition of the remains is not a factor. So long as some small portion of the creature's body still exists, it can be returned to life, but the portion receiving the spell must have been part of the creature's body at the time of death. (The remains of a creature hit by a disintegrate spell count as a small portion of its body.) The creature can have been dead for no longer than two hundred years. For each additional ten years, increase the Spellcraft DC by +1.

The creature is immediately restored to full hit points, vigor, and health, with no loss of prepared spells. However, the subject loses one level (or 1 point of Constitution if the subject was 1st level). The life seed cannot revive someone who has died of old age.

An epic caster with 24 ranks in Knowledge (arcana), Knowledge (nature), or Knowledge (religion) can cast a spell developed with a special version of the life seed that gives actual life to normally inanimate objects. The caster can give inanimate plants and animals a soul, personality, and humanlike sentience. To succeed, the caster must make a Will save (DC 10 + the target's Hit Dice, or the Hit Dice a plant will have once it comes to life).

The newly living object, intelligent animal, or sentient plant is friendly toward the caster. An object or plant has characteristics as if it were an animated object, except that its Intelligence, Wisdom, and Charisma scores are all 3d6. Animated objects and plants gain the ability to move their limbs, projections, roots, carved legs and arms, or other appendages, and have senses similar to a human's. A newly intelligent animal gets 3d6 Intelligence, +1d3 Charisma, and +2 HD. Objects, animals, and plants speak one language that the caster knows, plus one additional language that he or she knows per point of Intelligence bonus (if any).

"""
    , modes =
        [ { id = "life_resurrect"
          , name = "Resurrection"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "life_extra_decade", name = "Each additional 10 years beyond 200", description = "Target can have been dead longer", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "life_give"
          , name = "Give Life (to object/plant/animal)"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
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
    , description = """Attacks targeted against the caster rebound on the original attacker. Each use of the reflect seed in an epic spell is effective against one type of attack only: spells (and spell-like effects), ranged attacks, or melee attacks. To reflect an area spell, where the caster is not the target but are caught in the vicinity, increase the Spellcraft DC by +20. A single successful use of reflect expends its protection. Spells developed with the reflect seed against spells and spell-like effects return all spell effects of up to 1st level. For each additional level of spells to be reflected, increase the Spellcraft DC by +20. Epic spells are treated as 10th-level spells for this purpose.

The desired effect is automatically reflected if the spell in question is 9th level or lower. An opposed caster level check is required when the reflect seed is used against another epic spell. If the enemy spellcaster gets his spell through by winning the caster level check, the epic spell using the reflect seed is not expended, just momentarily suppressed.

If the reflect seed is used against a melee attack or ranged attack, five such attacks are automatically reflected back on the original attacker. For each additional attack reflected, increase the Spellcraft DC by +4. The reflected attack rebounds on the attacker using the same attack roll. Once the allotted attacks are reflected, the spell using the reflect seed is expended.

"""
    , modes =
        [ { id = "reflect_spell"
          , name = "Spell Reflection"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "reflect_aoe", name = "Reflect AoE spell (not directly targeted)", description = "", dcModifier = 20, kind = SeedToggle, maxQuantity = Just 1 }
                , { id = "reflect_spell_level", name = "Each additional spell level reflected", description = "Base reflects up to 1st level; each +1 level costs +20 DC; epic spells count as 10th level", dcModifier = 20, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "reflect_ranged"
          , name = "Ranged Attack Reflection"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "reflect_ranged_extra", name = "Each additional ranged attack reflected", description = "Base: 5 attacks", dcModifier = 4, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "reflect_melee"
          , name = "Melee Attack Reflection"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
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
    , description = """The caster of this seed can see some distant location or hear the sounds at some distant location almost as if he or she was there. To both hear and see, increase the Spellcraft DC by +2. Distance is not a factor, but the locale must be known—a place familiar to the caster or an obvious one. The spell creates an invisible sensor that can be dispelled. Lead sheeting or magical protection blocks the spell, and the caster senses that the spell is so blocked. If the caster prefers to create a mobile sensor (speed 30 feet) that he or she controls, increase the Spellcraft DC by +2. To use the reveal seed to reach one specific different plane of existence, increase the Spellcraft DC by +8. To allow magically enhanced senses to work through a spell built with the reveal seed, increase the Spellcraft DC by +4. To cast any spell from the sensor whose range is touch or greater, increase the Spellcraft DC by +6; however, the caster must maintain line of effect to the sensor at all times. If the line of effect is obstructed, the spell ends. To free the caster of the line of effect restriction for casting spells through the sensor, multiply the Spellcraft DC by ×10.

The reveal seed has a base Spellcraft DC of 25 if used to pierce illusions and see things as they really are. The caster can see through normal and magical darkness, notice secret doors hidden by magic, see the exact locations of creatures or objects under blur or displacement effects, see invisible creatures or objects normally, see through illusions, see onto the Ethereal Plane (but not into extradimensional spaces), and see the true form of polymorphed, changed, or transmuted things. The range of such sight is 120 feet.

The reveal seed can also be used to develop spells that will do any one of the following: duplicate the read magic spell, comprehend the written and verbal language of another, or speak in the written or verbal language of another. To both comprehend and speak a language, increase the Spellcraft DC by +4.

"""
    , modes =
        [ { id = "reveal_sensor"
          , name = "Sensor"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
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
          , durationOverride = Nothing
          , factors = []
          }
        , { id = "reveal_language"
          , name = "Languages"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
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
    , description = "A spell developed using the slay seed snuffs out the life force of a living creature, killing it instantly. The slay seed kills a creature of up to 80 HD. The subject is entitled to a Fortitude saving throw to survive the attack. If the save is successful, it instead takes 3d6+20 points of damage. For each additional 80 HD affected (or each additional creature affected), increase the Spellcraft DC by +8. Alternatively, a caster can use the slay seed in an epic spell to suppress the life force of the target by bestowing 2d4 negative levels on the target (or half as many negative levels on a successful Fortitude save). For each additional 1d4 negative levels bestowed, increase the Spellcraft DC by +4. If the subject has at least as many negative levels as Hit Dice, it dies. If the subject survives and the negative levels persist for 24 hours or longer, the subject must make another Fortitude saving throw, or the negative levels are converted to actual level loss."
    , modes =
        [ { id = "slay_kill"
          , name = "Kill"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "slay_hd", name = "Each additional 80 HD affected", description = "Or each additional creature affected", dcModifier = 8, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "slay_enervate"
          , name = "Enervate (negative levels)"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
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
    , description = """This seed can summon an outsider. It appears where the caster designates and acts immediately, on his or her turn, if its spell resistance is overcome and it fails a Will saving throw. It attacks the caster's opponents to the best of its ability. If the caster can communicate with the outsider, he or she can direct it not to attack, to attack particular enemies, or to perform other actions. The spell conjures an outsider the caster selects of CR 2 or less. For each +1 CR of the summoned outsider, increase the Spellcraft DC by +2. For each additional outsider of the same Challenge Rating summoned, multiply the Spellcraft DC by x2. When a caster develops a spell with the summon seed that summons an air, chaotic, earth, evil, fire, good, lawful, or water creature, the completed spell is also of that type.

If the caster increases the Spellcraft DC by +10, he or she can summon a creature of CR 2 or less from another monster type or subtype. The summoned creature is assumed to have been plucked from some other plane (or somewhere on the same plane). The summoned creature attacks the caster's opponents to the best of its ability; or, if the caster can communicate with it, it will perform other actions. However, the summoning ends if the creature is asked to perform a task inimical to its nature. For each +1 CR of the summoned creature, increase the Spellcraft DC by +2.

Finally, by increasing the Spellcraft DC by +60, the caster can summon a unique individual he or she specifies from anywhere in the multiverse. The caster must know the target's name and some facts about its life, defeat any magical protection against discovery or other protection possessed by the target, and overcome the target's spell resistance, and it must fail a Will saving throw. The target is under no special compulsion to serve the caster."""
    , modes =
        [ { id = "summon_generic"
          , name = "Summon Generic Creature"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "summon_cr", name = "Each +1 CR above CR 1", description = "", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
                , { id = "summon_nonoutsider", name = "Summon a non-outsider creature type", description = "+10 DC flat surcharge", dcModifier = 10, kind = SeedToggle, maxQuantity = Just 1 }

                -- Multiplying DC for multiple creatures is handled via a note; implement as a stackable that triggers multiply logic.
                ]
          }
        , { id = "summon_unique"
          , name = "Summon Unique Individual"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
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
    , description = """Spells using the transform seed change the subject into another form of creature or object. The new form can range in size from Diminutive to one size larger than the subject's normal form. For each additional increment of size change, increase the Spellcraft DC by +6. If the caster wants to transform a nonmagical, inanimate object into a creature of his or her type or transform a creature into a nonmagical, inanimate object, increase the Spellcraft DC by +10. To change a creature of one type into another type increase the Spellcraft DC by +5.

Transformations involving nonmagical, inanimate substances with hardness are more difficult; for each 2 points of hardness, increase the Spellcraft DC by +1.

To transform a creature into an incorporeal or gaseous form, increase the Spellcraft DC by +10. Conversely, to overcome the natural immunity of a gaseous or incorporeal creature to transformation, increase the Spellcraft DC by +10.

The transform seed can also change its target into someone specific. To transform an object or creature into the specific likeness of another individual (including memories and mental abilities), increase the Spellcraft DC by +25. If the transformed creature doesn't have the level or Hit Dice of its new likeness, it can only use the abilities of the creature at its own level or Hit Dice. If slain or destroyed, the transformed creature or object reverts to its original form. The subject's equipment, if any, remains untransformed or melds into the new form's body, at the caster's option. The transformed creature or object acquires the physical and natural abilities of the creature or object it has been changed into while retaining its own memories and mental ability scores. Mental abilities include personality, Intelligence, Wisdom, and Charisma scores, level and class, hit points (despite any change in its Constitution score), alignment, base attack bonus, base saves, extraordinary abilities, spells, and spell-like abilities, but not its supernatural abilities. Physical abilities include natural size and Strength, Dexterity, and Constitution scores. Natural abilities include armor, natural weapons, and similar gross physical qualities (presence or absence of wings, number of extremities, and so forth), and possibly hardness. Creatures transformed into inanimate objects do not gain the benefit of their untransformed physical abilities, and may well be blind, deaf, dumb, and unfeeling. Objects transformed into creatures gain that creature's average physical ability scores, but are considered to have mental ability scores of 0 (the fortify seed can add points to each mental ability, if desired). For each normal extraordinary ability or supernatural ability granted to the transformed creature, increase the Spellcraft DC by +10. The transformed subject can have no more Hit Dice than the caster has or than the subject has (whichever is greater). In any case, for each Hit Die the assumed form has above 15, increase the Spellcraft DC by +2."""
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
    , duration = "Instantaneous"
    , savingThrow = Nothing
    , spellResistance = False
    , description = """Spells using the transport seed instantly take the caster to a designated destination, regardless of distance. For interplanar travel, increase the Spellcraft DC by +4. For each additional 50 pounds in objects and willing creatures beyond the base 1,000 pounds, increase the Spellcraft DC by +2. The base use of the transport seed provides instantaneous travel through the Astral Plane. To shift the transportation medium to another medium increase the Spellcraft DC by +2. The caster does not need to make a saving throw, nor is spell resistance applicable to him or her. Only objects worn or carried (attended) by another person receive saving throws and spell resistance. For a spell intended to transport unwilling creatures, increase the Spellcraft DC by +4. The caster must have at least a reliable description of the place to which he or she is transporting. If the caster attempts to use the transport seed with insufficient or misleading information, the character disappears and simply reappear in his or her original location.

As a special use of the transport seed, a caster can develop a spell that temporarily transports him or her into a different time stream (leaving the caster in the same physical location); this increases the Spellcraft DC by +8. If the caster moves him or herself, or the subject, into a slower time stream for 5 rounds, time ceases to flow for the subject, and its condition becomes fixed—no force or effect can harm it until the duration expires. If the caster moves him or her self into a faster time stream, the caster speeds up so greatly that all other creatures seem frozen, though they are actually still moving at their normal speeds. The caster is free to act for 5 rounds of apparent time. Fire, cold, poison gas, and similar effects can still harm the caster. While the caster is in the fast time stream, other creatures are invulnerable to his or her attacks and spells; however, the caster can create spell effects and leave them to take effect when he or she reenters normal time. Because of the branching nature of time, epic spells used to transport a subject into a faster time stream cannot be made permanent, nor can the duration of 5 rounds be extended. More simply, the seed can haste or slow a subject for 20 rounds by transporting it to the appropriate time stream. This decreases the Spellcraft DC by -4."""
    , modes =
        [ { id = "transport_spatial"
          , name = "Spatial (Teleport)"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
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
          , durationOverride = Just "5 rounds"
          , factors =
                [ { id = "transport_temporal_dc", name = "Temporal transport surcharge", description = "+8 DC to enter a different time stream (freeze or accelerate)", dcModifier = 8, kind = SeedToggle, maxQuantity = Just 1 }
                ]
          }
        , { id = "transport_temporal_lite"
          , name = "Temporal Lite (haste/slow 20 rounds)"
          , baseDCOverride = Nothing
          , durationOverride = Just "20 rounds"
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
    , description = """This seed can grant a creature protection from damage of a specified type. The caster can protect a creature from standard damage or from energy damage. The caster can protect a creature or area from magic. Alternatively, he or she can hedge out a type of creature from a specified area. A ward against standard damage protects a creature from whichever two the caster selects of the three damage types: bludgeoning, piercing, and slashing. For a ward against all three types, increase the Spellcraft DC by +4. Each round, the spell created with the ward seed absorbs the first 5 points of damage the creature would otherwise take, regardless of whether the source of the damage is natural or magical. For each additional point of protection, increase the Spellcraft DC by +2.

A ward against energy grants a creature protection from whichever one the caster selects of the five energy types: acid, cold, electricity, fire, or sonic. Each round, the spell absorbs the first 5 points of damage the creature would otherwise take from the specified energy type, regardless of whether the source of damage is natural or magical. The spell protects the recipient's equipment as well. For each additional point of protection, increase the Spellcraft DC by +1.

A ward against a specific type of creature prevents bodily contact from whichever one of several monster types the caster selects. This causes the natural weapon attacks of such creatures to fail and the creatures to recoil if such attacks require touching the warded creature. The protection ends if the warded creature makes an attack against or intentionally moves within 5 feet of the blocked creature. Spell resistance can allow a creature to overcome this protection and touch the warded creature.

A ward against magic creates an immobile, faintly shimmering magical sphere (with radius 10 feet) that surrounds the caster and excludes all spell effects of up to 1st level. Alternatively, the caster can ward just the target and not create the radius effect. For each additional level of spells to be excluded, increase the Spellcraft DC by +20 (but see below). The area or effect of any such spells does not include the area of the ward, and such spells fail to affect any target within the ward. This includes spell-like abilities and spells or spell-like effects from magic items. However, any type of spell can be cast through or out of the ward. The caster can leave and return to the protected area without penalty (unless the spell specifically targets a creature and does not provide a radius effect). The ward could be brought down by a targeted dispel magic spell. Epic spells using the dispel seed may bring down a ward if the enemy spellcaster succeeds at a caster level check. The ward may also be brought down with a targeted epic spell using the destroy seed if the enemy spellcaster succeeds at a caster level check.

Instead of creating an epic spell that uses the ward seed to nullify all spells of a given level and lower, the caster can create a ward that nullifies a specific spell (or specific set of spells). For each specific spell so nullified, increase the Spellcraft DC by +2 per spell level above 1st."""
    , modes =
        [ { id = "ward_damage"
          , name = "Damage Ward (B/P/S)"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "ward_all_three", name = "Ward all three damage types (B, P, and S)", description = "Base covers two; +4 DC for all three", dcModifier = 4, kind = SeedToggle, maxQuantity = Just 1 }
                , { id = "ward_dmg_pts", name = "Each additional point of damage absorbed per round", description = "Above base 5", dcModifier = 2, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "ward_energy"
          , name = "Energy Ward"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors =
                [ { id = "ward_energy_pts", name = "Each additional point of energy absorbed per round", description = "Above base 5", dcModifier = 1, kind = SeedStackable, maxQuantity = Nothing }
                ]
          }
        , { id = "ward_creature"
          , name = "Creature Ward"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
          , factors = []
          }
        , { id = "ward_magic"
          , name = "Magic Ward (spell level exclusion)"
          , baseDCOverride = Nothing
          , durationOverride = Nothing
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
