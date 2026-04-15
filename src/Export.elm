module Export exposing (generateDescription, generateMarkdown)

import Calc exposing (calculateBreakdown, devCosts, statBlock)
import Dict exposing (Dict)
import Factors exposing (getFactor)
import Seeds exposing (getSeed)
import Types exposing (..)


-- ─── Description generation ───────────────────────────────────────────────────

generateDescription : List SeedInstance -> List AppliedFactor -> String
generateDescription instances globalFactors =
    let
        paragraphs =
            List.filterMap (seedInstanceParagraph globalFactors) instances

        additionalProps =
            buildAdditionalProps globalFactors
    in
    String.join "\n\n" paragraphs
        ++ (if String.isEmpty additionalProps then "" else "\n\n" ++ additionalProps)


seedInstanceParagraph : List AppliedFactor -> SeedInstance -> Maybe String
seedInstanceParagraph globalFactors inst =
    case getSeed inst.seedId of
        Nothing ->
            Nothing

        Just seed ->
            let
                modeId =
                    Maybe.withDefault "" inst.selectedMode

                choice id_ =
                    Dict.get id_ inst.choices |> Maybe.withDefault ""

                qty factorId =
                    inst.appliedSeedFactors
                        |> List.filter (\asf -> asf.factorId == factorId)
                        |> List.head
                        |> Maybe.map .quantity
                        |> Maybe.withDefault 0

                has factorId =
                    qty factorId > 0
            in
            Just (seedParagraph seed modeId inst globalFactors choice qty has)


seedParagraph : Seed -> String -> SeedInstance -> List AppliedFactor -> (String -> String) -> (String -> Int) -> (String -> Bool) -> String
seedParagraph seed modeId inst _ choice qty has =
    case seed.id of
        Afflict ->
            let
                penaltyRolls = 2 + qty "afflict_rolls"
                otherPenalties = qty "afflict_other"
                senseCount = qty "afflict_sense"
                otherStr =
                    if otherPenalties > 0 then
                        " The target is also afflicted with a –" ++ String.fromInt otherPenalties ++ " penalty to caster level checks, ability scores, and Spell Resistance."
                    else ""
                senseStr =
                    if senseCount > 0 then
                        " One of the target's senses ceases to function for the spell's duration, with all attendant penalties that apply for losing that sense."
                    else ""
            in
            "This spell afflicts the target with a –" ++ String.fromInt penaltyRolls ++ " morale penalty on attack rolls, checks, and saving throws." ++ otherStr ++ senseStr

        Animate ->
            let vol = 20 + qty "animate_vol_1k" * 10 + qty "animate_vol_over1k" * 100
                attended = if has "animate_attended" then " The spell can animate objects carried or worn by another creature." else ""
            in
            "This spell imbues up to " ++ String.fromInt vol ++ " cubic feet of inanimate matter with mobility and a semblance of life. The animated object attacks whomever or whatever the caster designates and can be of any nonmagical material." ++ attended

        AnimateDead ->
            let hd = 20 + qty "adead_extra_hd_create"
                undeadType = undead_type_from_factors inst
            in
            "This spell turns the bones or bodies of dead creatures into up to " ++ String.fromInt hd ++ " Hit Dice of " ++ undeadType ++ " undead that follow the caster's spoken commands. The undead can accompany the caster or remain in an area and attack any creature entering it. They remain animated until destroyed."

        Armor ->
            let bonus = 4 + qty "armor_ac_bonus"
                other = qty "armor_other_type"
                otherStr = if other > 0 then " The target also gains a +" ++ String.fromInt other ++ " bonus to Armor Class of a different type, such as deflection, divine, or insight." else ""
            in
            "This spell grants the target a +" ++ String.fromInt bonus ++ " armor or natural armor bonus to Armor Class, whichever the caster selects. Unlike mundane armor, this protection entails no armor check penalty, arcane spell failure chance, or speed reduction. Incorporeal creatures can't bypass it the way they can ignore normal armor." ++ otherStr

        Banish ->
            let hd = 14 + qty "banish_hd" * 2
                typeStr = if has "banish_type" then " The spell targets a specified creature type or subtype other than outsiders." else ""
            in
            "This spell forces up to " ++ String.fromInt hd ++ " Hit Dice of extraplanar creatures out of the caster's home plane." ++ typeStr

        Compel ->
            let
                restriction = if has "compel_unreasonable"
                    then " The compelled activity need not sound reasonable to the target and can include obviously harmful acts."
                    else " The activity must be worded so as to sound reasonable to the target; asking it to do an obviously harmful act automatically negates the effect."
            in
            "This spell compels the target to follow a course of activity." ++ restriction ++ " The compelled activity can continue for the entire duration, or the spell ends early when the task is completed."

        Conceal ->
            case modeId of
                "conceal_invisibility" ->
                    let persist = if has "conceal_persist"
                            then " This invisibility lasts regardless of the subject's actions, including attacking."
                            else " The spell ends if the subject attacks any creature."
                    in
                    "This spell conceals the target from sight, even from darkvision. If the subject is a creature carrying gear, the gear vanishes too, rendering the creature invisible." ++ persist
                "conceal_displacement" ->
                    "This spell conceals the exact location of the target, making it appear to be about 2 feet away from its true location. The subject benefits from a 50% miss chance as if it had total concealment. However, unlike actual total concealment, this displacement effect does not prevent enemies from targeting the subject normally."
                _ ->
                    "This spell blocks divination spells, spell-like effects, and epic spells developed with the reveal seed from affecting the subject. Whenever such magic is directed against the subject, an opposed caster level check determines which spell prevails."

        Conjure ->
            case modeId of
                "conjure_creature" ->
                    "This spell, in conjunction with the Life and Fortify seeds, creates an entirely new creature if made permanent. The new creature breeds true once successfully created."
                _ ->
                    let vol = 20 + qty "conjure_vol"
                    in "This spell conjures " ++ String.fromInt vol ++ " cubic feet of nonmagical, nonliving matter. The conjured material ranges from simple vegetation to rare metals such as mithral or adamantine."

        Contact ->
            case modeId of
                "contact_messenger" ->
                    "This spell imbues a creature or object with a prepared message that appears as text or is spoken aloud when specific conditions are met."
                _ ->
                    let extra = qty "contact_extra_creature"
                        lang = if has "contact_language" then " The bond allows telepathic communication regardless of language." else ""
                        extraStr = if extra > 0 then " Up to " ++ String.fromInt (2 + extra) ++ " creatures can share the bond." else ""
                    in
                    "This spell forges a telepathic bond with a known or visible creature, allowing two-way communication across any distance." ++ extraStr ++ lang

        Delude ->
            let
                senses = qty "delude_sense"
                images = qty "delude_extra_image"
                script = has "delude_script"
                area = has "delude_area"
                senseStr = if senses > 0 then " The illusion also includes " ++ String.fromInt senses ++ " additional sensory aspect(s) beyond vision." else ""
                imageStr = if images > 0 then " The spell creates " ++ String.fromInt (1 + images) ++ " images total." else ""
                scriptStr = if script then " The illusion follows a predetermined script without the caster's concentration." else ""
                areaStr = if area then " The illusion makes an entire area appear to be something other than it is." else ""
            in
            "This spell creates a visual illusion that the caster can move by concentrating. The illusion disappears when struck unless the caster responds appropriately." ++ senseStr ++ imageStr ++ scriptStr ++ areaStr

        Destroy ->
            let dmg = 20 + qty "destroy_damage"
            in
            "This spell deals " ++ String.fromInt dmg ++ "d6 points of damage to the target (no specific type). A creature reduced to –10 hit points or less is utterly destroyed, leaving only fine dust."

        Dispel ->
            let bonus = 10 + qty "dispel_bonus"
            in
            "This spell ends ongoing magical effects on the target. The caster makes a dispel check (1d20 +" ++ String.fromInt bonus ++ ") against DC 11 + the target spell's caster level. It can defeat any spell, including epic ones and supernatural abilities."

        Energy ->
            let
                eType = if String.isEmpty (choice "energyType") then "fire" else choice "energyType"
            in
            case modeId of
                "energy_bolt" ->
                    let dmg = 10 + qty "energy_bolt_damage"
                        imbue = if has "energy_bolt_imbue" then " Another creature is imbued with the ability to use this bolt as a spell-like ability." else ""
                    in
                    "This spell releases a bolt of " ++ eType ++ " energy that deals " ++ String.fromInt dmg ++ "d6 points of " ++ eType ++ " damage to all in its path. A successful Reflex save halves the damage." ++ imbue
                "energy_emanation" ->
                    let dmg = 2 + qty "energy_em_damage"
                    in
                    "This spell causes the target to emanate " ++ eType ++ " energy in a 10-foot radius for the duration, dealing " ++ String.fromInt dmg ++ "d6 points of " ++ eType ++ " damage per round to unprotected creatures."
                "energy_wall" ->
                    let dmgNear = 2 + qty "energy_wall_damage"
                        dmgFar = 1 + qty "energy_wall_damage"
                    in
                    "This spell creates a wall of " ++ eType ++ " energy, dealing " ++ String.fromInt dmgNear ++ "d4 damage to creatures within 10 feet, " ++ String.fromInt dmgFar ++ "d4 damage to creatures between 10–20 feet, and 2d6+20 damage to any creature that passes through it."
                "energy_weather" ->
                    "This spell carefully releases cold, electricity, and fire to create specific weather effects (blizzards, heat waves, storms, fogs, or tornadoes) in a two-mile radius for the duration. Targeted damage requires an additional use of the Energy seed."
                _ ->
                    "This spell channels " ++ eType ++ " energy. Select a mode (bolt, emanation, wall, or weather) to define the effect."

        Foresee ->
            case modeId of
                "foresee_questions" ->
                    "This spell allows the caster to pose up to ten specific questions to unknown powers of other planes. Each answer is one word (yes, no, maybe, never, irrelevant, or similar) and is 90% likely to be truthful."
                "foresee_info" ->
                    let info = 1 + qty "foresee_extra_info"
                    in
                    "This spell reveals " ++ String.fromInt info ++ " piece(s) of basic information about a living target—such as level, class, alignment, or a special ability."
                _ ->
                    let intervals = qty "foresee_interval"
                        minutes = (1 + intervals) * 30
                    in
                    "This spell foretells the immediate future up to " ++ String.fromInt minutes ++ " minutes ahead. The caster is 90% likely to receive a meaningful reading indicating whether a contemplated action will bring good, bad, or no results."

        Fortify ->
            case modeId of
                "fortify_enhance" ->
                    let bonus = 1 + qty "fortify_enhance_plus"
                    in
                    "This spell grants the target a +" ++ String.fromInt bonus ++ " enhancement bonus to one ability score, saving throw, spell resistance, natural armor, energy resistance, or temporary hit points."
                "fortify_nonenhance" ->
                    let bonus = 1 + qty "fortify_other_plus"
                    in
                    "This spell grants the target a +" ++ String.fromInt bonus ++ " non-enhancement bonus (such as insight, sacred, or profane) to one statistic."
                "fortify_new" ->
                    let bonus = 1 + qty "fortify_new_plus"
                    in
                    "This spell grants the target a +" ++ String.fromInt bonus ++ " bonus to a statistic it does not normally possess."
                "fortify_sr" ->
                    let srBase = 25 + qty "fortify_sr_plus" - qty "fortify_sr_minus"
                        epicDR = if has "fortify_dr_epic" then " The damage reduction provided penetrates epic defenses." else ""
                    in
                    "This spell grants the target Spell Resistance " ++ String.fromInt srBase ++ "." ++ epicDR
                "fortify_age" ->
                    let years = qty "fortify_age_year"
                    in
                    "This spell permanently extends the target's current age category by " ++ String.fromInt years ++ " year(s)."
                _ ->
                    "This spell fortifies the target with a bonus to one statistic or ability."

        Heal ->
            case modeId of
                "heal_harm" ->
                    let negLevels = 4 + qty "heal_neg_level_extra"
                    in
                    "This spell flushes negative energy into the target, healing undead completely but inflicting " ++ String.fromInt negLevels ++ " negative levels on living creatures (Fortitude save for half)."
                _ ->
                    let drain = if has "heal_drain" then " It also restores permanently drained ability score points." else ""
                        negLevels = if has "heal_neg_levels" then " All negative levels afflicting the target are dispelled." else ""
                    in
                    "This spell channels positive energy to completely cure all diseases, blindness, deafness, hit point damage, temporary ability damage, poisons, and magical penalties afflicting the target." ++ drain ++ negLevels

        Life ->
            case modeId of
                "life_give" ->
                    "This spell grants actual life, personality, and humanlike sentience to an inanimate object, plant, or animal. The newly living creature is friendly toward the caster and speaks one language per point of Intelligence bonus."
                _ ->
                    let decades = qty "life_extra_decade"
                        yearLimit = 200 + decades * 10
                    in
                    "This spell restores life and complete vigor to a creature that has been dead for no more than " ++ String.fromInt yearLimit ++ " years, regardless of the state of its remains. The subject loses one level (or 1 Constitution if 1st level) upon returning."

        Reflect ->
            case modeId of
                "reflect_ranged" ->
                    let attacks = 5 + qty "reflect_ranged_extra"
                    in
                    "This spell reflects the next " ++ String.fromInt attacks ++ " ranged attacks made against the caster back on their originators, using the original attack rolls."
                "reflect_melee" ->
                    let attacks = 5 + qty "reflect_melee_extra"
                    in
                    "This spell reflects the next " ++ String.fromInt attacks ++ " melee attacks made against the caster back on their originators, using the original attack rolls."
                _ ->
                    let levelCap = qty "reflect_spell_level"
                        aoe = if has "reflect_aoe" then " It can reflect area-of-effect spells that catch the caster in their vicinity." else ""
                        capStr = if levelCap > 0 then String.fromInt (1 + levelCap) else "1"
                    in
                    "This spell reflects spells and spell-like effects of up to " ++ capStr ++ "th level back on their casters. Epic spells require an opposed caster level check to reflect." ++ aoe

        Reveal ->
            case modeId of
                "reveal_truesight" ->
                    "This spell grants the caster true sight to a range of 120 feet, piercing all mundane and magical darkness, illusions, blur, displacement, and invisibility."
                "reveal_language" ->
                    let both = if has "reveal_both_lang" then " The caster can both comprehend and speak the language." else " The caster can comprehend the language." in
                    "This spell grants the ability to understand a foreign written or spoken language." ++ both
                _ ->
                    let
                        hear = if has "reveal_hear" then " The caster can both see and hear through the sensor." else " The caster can see through the sensor."
                        mobile = if has "reveal_mobile" then " The sensor is mobile (speed 30 ft.)." else ""
                        plane = if has "reveal_plane" then " The sensor can be placed on a different plane." else ""
                        cast = if has "reveal_cast_through" then " The caster can cast touch-range or greater spells through the sensor (must maintain line of effect)." else ""
                        noLoe = if has "reveal_no_loe" then " No line of effect is required for spells cast through the sensor." else ""
                    in
                    "This spell creates an invisible sensor at a known location, allowing the caster to observe remotely." ++ hear ++ mobile ++ plane ++ cast ++ noLoe

        Slay ->
            case modeId of
                "slay_enervate" ->
                    let dice = 2 + qty "slay_neg_level"
                    in
                    "This spell suppresses the life force of the target, bestowing " ++ String.fromInt dice ++ "d4 negative levels (Fortitude save for half). If negative levels equal or exceed the target's Hit Dice, it dies."
                _ ->
                    let extraHD = qty "slay_hd"
                        targets = if extraHD > 0 then String.fromInt (1 + extraHD) ++ " additional targets or groups of" else "a creature of up to"
                    in
                    "This spell snuffs out the life force of " ++ targets ++ " 80 Hit Dice. If the target fails a Fortitude save, it dies instantly. On a successful save, it instead takes 3d6+20 points of damage."

        Summon ->
            case modeId of
                "summon_unique" ->
                    "This spell summons a specific named individual from anywhere in the multiverse. The target must be known to the caster, and the caster must overcome the target's magical protections, Spell Resistance, and Will save. The target is under no compulsion to serve."
                _ ->
                    let crBonus = qty "summon_cr"
                        cr = 1 + crBonus
                        nonOutsider = if has "summon_nonoutsider" then " The summoned creature is not an outsider." else " The summoned creature is an outsider."
                    in
                    "This spell summons a CR " ++ String.fromInt cr ++ " creature that attacks the caster's opponents to the best of its ability." ++ nonOutsider

        Transform ->
            let
                specific = if has "transform_specific" then " The target is transformed into the specific likeness of another individual, including memories and mental abilities." else ""
                incorporeal = if has "transform_incorporeal" then " The transformation involves an incorporeal or gaseous form." else ""
            in
            "This spell transforms the target into another form of creature or object. The transformed subject retains its mental abilities and scores but gains the physical attributes of its new form." ++ specific ++ incorporeal

        Transport ->
            case modeId of
                "transport_temporal" ->
                    "This spell shifts the caster into a different time stream for 5 rounds. In a slow time stream, the subject is frozen and invulnerable. In a fast time stream, all other creatures appear frozen while the caster acts freely for 5 rounds."
                "transport_temporal_lite" ->
                    "This spell hastens or slows the target for 20 rounds by briefly shifting it into an accelerated or decelerated time stream."
                _ ->
                    let
                        interplanar = if has "transport_interplanar" then " The destination can be on a different plane." else ""
                        unwilling = if has "transport_unwilling" then " The spell can target unwilling creatures (Will save negates)." else ""
                    in
                    "This spell instantly transports the caster and willing companions (up to 1,000 lb.) to a designated destination." ++ interplanar ++ unwilling

        Ward ->
            case modeId of
                "ward_energy" ->
                    let pts = 5 + qty "ward_energy_pts"
                        eType = if String.isEmpty (choice "wardEnergyType") then "the chosen energy type" else choice "wardEnergyType"
                    in
                    "This spell protects the target, absorbing the first " ++ String.fromInt pts ++ " points of " ++ eType ++ " damage it would take each round."
                "ward_creature" ->
                    let cType = if String.isEmpty (choice "wardCreatureType") then "the chosen creature type" else choice "wardCreatureType"
                    in
                    "This spell prevents bodily contact by " ++ cType ++ ". Their natural weapon attacks fail and they recoil if they must touch the warded creature."
                "ward_magic" ->
                    let lvl = 1 + qty "ward_magic_level"
                    in
                    "This spell creates a 10-foot-radius sphere around the caster that blocks all spells of " ++ String.fromInt lvl ++ "th level and below. Spells can still be cast outward from within the ward."
                _ ->
                    let pts = 5 + qty "ward_dmg_pts"
                        allThree = if has "ward_all_three" then "all three types (bludgeoning, piercing, and slashing)" else "two of the three damage types (bludgeoning, piercing, or slashing)"
                    in
                    "This spell absorbs the first " ++ String.fromInt pts ++ " points of physical damage the target would take each round from " ++ allThree ++ "."


-- Helper: determine undead type for Animate Dead paragraph
undead_type_from_factors : SeedInstance -> String
undead_type_from_factors inst =
    let
        typeMap =
            [ ( "adead_skeleton", "skeleton" )
            , ( "adead_zombie", "zombie" )
            , ( "adead_ghoul", "ghoul" )
            , ( "adead_shadow", "shadow" )
            , ( "adead_ghast", "ghast" )
            , ( "adead_wight", "wight" )
            , ( "adead_wraith", "wraith" )
            , ( "adead_mummy", "mummy" )
            , ( "adead_spectre", "spectre" )
            , ( "adead_mohrg", "mohrg" )
            , ( "adead_vampire", "vampire" )
            , ( "adead_ghost", "ghost" )
            ]
    in
    typeMap
        |> List.filter (\( id_, _ ) -> List.any (\asf -> asf.factorId == id_ && asf.quantity > 0) inst.appliedSeedFactors)
        |> List.head
        |> Maybe.map Tuple.second
        |> Maybe.withDefault "mixed"


-- Additional properties block (factors that don't fit into stat block or seed paragraphs)
buildAdditionalProps : List AppliedFactor -> String
buildAdditionalProps globalFactors =
    let
        props =
            List.filterMap
                (\af ->
                    case af.factorId of
                        Backlash ->
                            Just ("Backlash: The caster takes " ++ String.fromInt af.quantity ++ "d6 damage upon casting this spell.")
                        XPBurn ->
                            Just ("XP Cost: The caster must expend " ++ String.fromInt (af.quantity * 100) ++ " XP when casting this spell.")
                        Contingent ->
                            Just "Contingent: This spell is stored and fires automatically when a specified trigger condition is met."
                        IncreaseSRCheck ->
                            Just ("The caster gains +" ++ String.fromInt af.quantity ++ " to caster level checks against Spell Resistance when casting this spell.")
                        IncreaseVsDispel ->
                            Just ("The spell gains +" ++ String.fromInt af.quantity ++ " to resist dispel effects.")
                        StoneTablet ->
                            Just "This spell is inscribed on a stone tablet. Other epic spellcasters may learn it by studying the tablet (which is destroyed in the process)."
                        RitualSlot1 ->
                            Just (ritualLine af.quantity "1st")
                        RitualSlot2 ->
                            Just (ritualLine af.quantity "2nd")
                        RitualSlot3 ->
                            Just (ritualLine af.quantity "3rd")
                        RitualSlot4 ->
                            Just (ritualLine af.quantity "4th")
                        RitualSlot5 ->
                            Just (ritualLine af.quantity "5th")
                        RitualSlot6 ->
                            Just (ritualLine af.quantity "6th")
                        RitualSlot7 ->
                            Just (ritualLine af.quantity "7th")
                        RitualSlot8 ->
                            Just (ritualLine af.quantity "8th")
                        RitualSlot9 ->
                            Just (ritualLine af.quantity "9th")
                        RitualSlotEpic ->
                            Just (ritualLine af.quantity "epic")
                        _ ->
                            Nothing
                )
                globalFactors
    in
    if List.isEmpty props then
        ""
    else
        "### Additional Properties\n\n" ++ String.join "\n" (List.map (\p -> "- " ++ p) props)


ritualLine : Int -> String -> String
ritualLine count slotLevel =
    "Ritual: Requires " ++ String.fromInt count ++ " additional caster(s) each expending a " ++ slotLevel ++ "-level spell slot."


-- ─── Markdown export ──────────────────────────────────────────────────────────

generateMarkdown : String -> List SeedInstance -> List AppliedFactor -> String -> Int -> String
generateMarkdown spellName instances globalFactors description casterSaveDCBonus =
    let
        breakdown =
            calculateBreakdown instances globalFactors

        costs =
            devCosts breakdown.finalDC

        sb =
            statBlock instances globalFactors casterSaveDCBonus

        seedList =
            instances
                |> List.filterMap
                    (\inst ->
                        getSeed inst.seedId
                            |> Maybe.map (\s -> s.name ++ " (" ++ String.fromInt s.baseDC ++ ")")
                    )
                |> String.join ", "

        augDesc =
            globalFactors
                |> List.filterMap
                    (\af ->
                        getFactor af.factorId
                            |> Maybe.andThen
                                (\f ->
                                    if f.category == Augmenting then
                                        Just (f.name ++ (if af.quantity > 1 then " ×" ++ String.fromInt af.quantity else "") ++ " (" ++ showSign (f.dcModifier * af.quantity) ++ ")")
                                    else
                                        Nothing
                                )
                    )
                |> String.join "; "

        mitDesc =
            globalFactors
                |> List.filterMap
                    (\af ->
                        getFactor af.factorId
                            |> Maybe.andThen
                                (\f ->
                                    if f.category == Mitigating then
                                        Just (f.name ++ (if af.quantity > 1 then " ×" ++ String.fromInt af.quantity else "") ++ " (" ++ showSign (f.dcModifier * af.quantity) ++ ")")
                                    else
                                        Nothing
                                )
                    )
                |> String.join "; "

        descriptorStr =
            if List.isEmpty sb.descriptors then ""
            else " [" ++ String.join ", " sb.descriptors ++ "]"

        title =
            if String.isEmpty spellName then "Unnamed Spell" else spellName
    in
    "# " ++ title ++ "\n\n"
        ++ "**Spellcraft DC:** " ++ String.fromInt breakdown.finalDC ++ "  \n"
        ++ "**School:** " ++ sb.school ++ descriptorStr ++ "  \n"
        ++ "**Components:** " ++ String.join ", " sb.components ++ "  \n"
        ++ "**Casting Time:** " ++ sb.castingTime ++ "  \n"
        ++ "**Range:** " ++ sb.range ++ "  \n"
        ++ "**Target/Area/Effect:** " ++ sb.targetAreaEffect ++ "  \n"
        ++ "**Duration:** " ++ sb.duration ++ "  \n"
        ++ "**Saving Throw:** " ++ sb.savingThrow ++ "  \n"
        ++ "**Spell Resistance:** " ++ sb.spellResistance ++ "\n\n"
        ++ "## Description\n\n"
        ++ description ++ "\n\n"
        ++ "## Development\n\n"
        ++ "| | |\n|---|---|\n"
        ++ "| Seeds | " ++ seedList ++ " |\n"
        ++ (if breakdown.seedFactorsTotal /= 0 then "| Seed Factor DC | " ++ showSign breakdown.seedFactorsTotal ++ " |\n" else "")
        ++ (if String.isEmpty augDesc then "" else "| Augmenting | " ++ augDesc ++ " |\n")
        ++ (if breakdown.permanentMultiplier > 1 then "| Permanent Duration | ×5 multiplier |\n" else "")
        ++ (if breakdown.stoneTabletMultiplier > 1 then "| Stone Tablet | ×2 multiplier |\n" else "")
        ++ (if String.isEmpty mitDesc then "" else "| Mitigating | " ++ mitDesc ++ " |\n")
        ++ "| **Final Spellcraft DC** | **" ++ String.fromInt breakdown.finalDC ++ "** |\n"
        ++ "| Gold Cost | " ++ formatNum costs.goldCost ++ " gp |\n"
        ++ "| Development Time | " ++ String.fromInt costs.timeDays ++ " days |\n"
        ++ "| XP Cost | " ++ formatNum costs.xpCost ++ " XP |\n"


showSign : Int -> String
showSign n =
    if n >= 0 then "+" ++ String.fromInt n else String.fromInt n


formatNum : Int -> String
formatNum n =
    let str = String.fromInt n
        len = String.length str
    in
    if len <= 3 then str
    else formatNum (n // 1000) ++ "," ++ String.padLeft 3 '0' (String.fromInt (modBy 1000 n))
