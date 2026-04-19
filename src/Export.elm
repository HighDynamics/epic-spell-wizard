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
seedParagraph seed modeId inst globalFactors choice qty has =
    case seed.id of
        Afflict ->
            let
                penaltyRolls =
                    2 + qty "afflict_rolls"

                senseCount =
                    qty "afflict_sense"

                isPermanent =
                    List.any (\af -> af.factorId == PermanentDuration) globalFactors

                isExtended =
                    List.any (\af -> af.factorId == IncreaseDuration) globalFactors

                abilityPhrase stat n =
                    if isPermanent then
                        "a –" ++ String.fromInt n ++ " permanent " ++ stat ++ " drain"
                    else if isExtended then
                        "a –" ++ String.fromInt n ++ " temporary " ++ stat ++ " damage"
                    else
                        "a –" ++ String.fromInt n ++ " penalty to " ++ stat

                extraClauses =
                    List.filterMap identity
                        (List.map
                            (\( stat, fid ) ->
                                let
                                    n =
                                        qty fid
                                in
                                if n > 0 then
                                    Just (abilityPhrase stat n)
                                else
                                    Nothing
                            )
                            [ ( "Strength", "afflict_ability_str" )
                            , ( "Dexterity", "afflict_ability_dex" )
                            , ( "Constitution", "afflict_ability_con" )
                            , ( "Intelligence", "afflict_ability_int" )
                            , ( "Wisdom", "afflict_ability_wis" )
                            , ( "Charisma", "afflict_ability_cha" )
                            ]
                            ++ [ if qty "afflict_cl" > 0 then Just ("a –" ++ String.fromInt (qty "afflict_cl") ++ " penalty to caster level checks") else Nothing
                               , if qty "afflict_sr" > 0 then Just ("a –" ++ String.fromInt (qty "afflict_sr") ++ " penalty to spell resistance") else Nothing
                               , if qty "afflict_other" > 0 then Just ("a –" ++ String.fromInt (qty "afflict_other") ++ " penalty to another aspect of the target") else Nothing
                               ]
                        )

                extraStr =
                    if List.isEmpty extraClauses then
                        ""
                    else
                        " The target also suffers " ++ joinClauses extraClauses ++ "."

                senseStr =
                    if senseCount > 0 then
                        " One of the target's senses ceases to function for the spell's duration, with all attendant penalties that apply for losing that sense."
                    else
                        ""
            in
            "This spell afflicts the target with a –" ++ String.fromInt penaltyRolls ++ " morale penalty on attack rolls, checks, and saving throws." ++ extraStr ++ senseStr

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
                    "This spell, used in conjunction with the Life and Fortify seeds, creates an entirely new creature if made permanent. Once successfully created, the new creature will breed true."
                _ ->
                    let vol = 20 + qty "conjure_vol"
                    in "This spell creates a nonmagical, unattended object of nonliving matter of up to " ++ String.fromInt vol ++ " cubic feet in volume. The caster must succeed at an appropriate skill check to make a complex item. The conjured material can range from vegetable matter all the way up to mithral and even adamantine."

        Contact ->
            case modeId of
                "contact_messenger" ->
                    "This spell imbues a creature or object with a message the caster prepares, which appears as written text or is spoken aloud when specific conditions set at casting are fulfilled."
                _ ->
                    let extra = qty "contact_extra_creature"
                        lang = if has "contact_language" then " The bond allows telepathic communication regardless of language." else ""
                        extraStr = if extra > 0 then " The caster can forge a communal bond among up to " ++ String.fromInt (2 + extra) ++ " creatures." else ""
                    in
                    "This spell forges a telepathic bond with a creature familiar to the caster, or one the caster can currently see. The subject recognizes the caster if it knows him or her and can answer in like manner, though it does not have to." ++ extraStr ++ lang

        Delude ->
            let
                senses = qty "delude_sense"
                images = qty "delude_extra_image"
                script = has "delude_script"
                area = has "delude_area"
                senseStr = if senses > 0 then " The illusion includes " ++ String.fromInt senses ++ " additional sensory aspect(s), such as sound, smell, or touch." else ""
                imageStr = if images > 0 then " The spell creates " ++ String.fromInt (1 + images) ++ " images." else ""
                scriptStr = if script then " The figment follows a script determined by the caster, without requiring concentration. It can include intelligible speech." else ""
                areaStr = if area then " The illusion makes an entire area appear to be something other than it is." else ""
            in
            "This spell creates the visual illusion of an object, creature, or force, as visualized by the caster. The caster can move the image by concentrating; it is otherwise stationary. The image disappears when struck by an opponent unless the caster causes the illusion to react appropriately." ++ senseStr ++ imageStr ++ scriptStr ++ areaStr

        Destroy ->
            let dmg = 20 + qty "destroy_damage"
            in
            "This spell deals " ++ String.fromInt dmg ++ "d6 points of damage to the target. The damage is of no particular type or energy. If the target is reduced to –10 hit points or less—or a construct, object, or undead is reduced to 0 hit points—it is utterly destroyed as if disintegrated, leaving behind only a trace of fine dust."

        Dispel ->
            let bonus = 10 + qty "dispel_bonus"
            in
            "This spell can end ongoing spells on a creature or object, temporarily suppress the magical abilities of a magic item, or end ongoing spell effects within an area. A dispelled spell ends as if its duration had expired. The caster makes a dispel check (1d20 +" ++ String.fromInt bonus ++ ") against a DC of 11 + the target spell's caster level. The dispel seed can defeat all spells, even those not normally subject to dispel magic, including epic spells and supernatural abilities."

        Energy ->
            let
                eType = if String.isEmpty (choice "energyType") then "fire" else choice "energyType"
            in
            case modeId of
                "energy_bolt" ->
                    let dmg = 10 + qty "energy_bolt_damage"
                        imbue = if has "energy_bolt_imbue" then " Another creature is imbued with the ability to use this bolt as a spell-like ability at its option or when a particular condition is met." else ""
                    in
                    "This spell releases a bolt of " ++ eType ++ " energy that instantaneously deals " ++ String.fromInt dmg ++ "d6 points of " ++ eType ++ " damage; all in the bolt's area must make a Reflex save for half damage." ++ imbue
                "energy_emanation" ->
                    let dmg = 2 + qty "energy_em_damage"
                    in
                    "This spell causes the target to emanate " ++ eType ++ " energy out to a radius of 10 feet, dealing " ++ String.fromInt dmg ++ "d6 points of " ++ eType ++ " damage per round against unprotected creatures."
                "energy_wall" ->
                    let dmgNear = 2 + qty "energy_wall_damage"
                        dmgFar = 1 + qty "energy_wall_damage"
                    in
                    "This spell creates a wall, dome, or sphere of " ++ eType ++ " energy. One side sends forth waves of energy, dealing " ++ String.fromInt dmgNear ++ "d4 points of damage to creatures within 10 feet and " ++ String.fromInt dmgFar ++ "d4 points to those within 20 feet. Any creature passing through the wall takes 2d6+20 points of " ++ eType ++ " damage. The wall deals double damage to undead."
                "energy_weather" ->
                    "This spell carefully releases and balances cold, electricity, and fire to create specific weather effects in a two-mile radius centered on the caster. It can create cold snaps, heat waves, thunderstorms, fogs, blizzards, or even a tornado that moves randomly through the area. Creating targeted damaging effects requires an additional use of the energy seed."
                _ ->
                    "This spell channels " ++ eType ++ " energy. Select a mode (bolt, emanation, wall, or weather) to define the effect."

        Foresee ->
            case modeId of
                "foresee_questions" ->
                    "This spell allows the caster to pose up to ten specific questions to unknown powers of other planes, one per round while concentrating. The answers return in a language the caster understands, using only one-word replies—yes, no, maybe, never, irrelevant, or similar—and are 90% likely to be truthful."
                "foresee_info" ->
                    let info = 1 + qty "foresee_extra_info"
                    in
                    "This spell reveals " ++ String.fromInt info ++ " basic piece(s) of information about a living target—such as level, class, alignment, or a special ability."
                _ ->
                    let intervals = qty "foresee_interval"
                        minutes = (1 + intervals) * 30
                    in
                    "This spell foretells the immediate future up to " ++ String.fromInt minutes ++ " minutes ahead. The caster is 90% likely to receive a meaningful reading indicating whether a contemplated action will bring good results, bad results, or no result."

        Fortify ->
            case modeId of
                "fortify_enhance" ->
                    let bonus = 1 + qty "fortify_enhance_plus"
                    in
                    "This spell grants the target a +" ++ String.fromInt bonus ++ " enhancement bonus to one ability score, saving throw, spell resistance, natural armor, energy resistance, or temporary hit points."
                "fortify_nonenhance" ->
                    let bonus = 1 + qty "fortify_other_plus"
                    in
                    "This spell grants the target a +" ++ String.fromInt bonus ++ " bonus of a type other than enhancement (such as insight, sacred, or profane) to one statistic."
                "fortify_new" ->
                    let bonus = 1 + qty "fortify_new_plus"
                    in
                    "This spell grants the target a +" ++ String.fromInt bonus ++ " bonus to an ability score or statistic it does not normally possess."
                "fortify_sr" ->
                    let srBase = 25 + qty "fortify_sr_plus" - qty "fortify_sr_minus"
                        epicDR = if has "fortify_dr_epic" then " The granted damage reduction is effective against epic attacks." else ""
                    in
                    "This spell grants the target Spell Resistance " ++ String.fromInt srBase ++ "." ++ epicDR
                "fortify_age" ->
                    let years = qty "fortify_age_year"
                    in
                    "This spell permanently adds " ++ String.fromInt years ++ " year(s) to the target's current age category. Incremental adjustments do not stack; they overlap."
                _ ->
                    "This spell fortifies the target with a bonus to one statistic or ability."

        Heal ->
            case modeId of
                "heal_harm" ->
                    let negLevels = 4 + qty "heal_neg_level_extra"
                    in
                    "This spell flushes negative energy into the target, healing undead completely. A living target that fails its Fortitude saving throw gains " ++ String.fromInt negLevels ++ " negative levels. If the subject has at least as many negative levels as Hit Dice, it dies."
                _ ->
                    let drain = if has "heal_drain" then " It also restores permanently drained ability score points." else ""
                        negLevels = if has "heal_neg_levels" then " All negative levels afflicting the target are dispelled." else ""
                    in
                    "This spell channels positive energy to completely cure all diseases, blindness, deafness, hit point damage, and temporary ability damage afflicting the target. It neutralizes poisons, offsets feeblemindedness, cures mental disorders, and dispels all magical effects penalizing the target's abilities." ++ drain ++ negLevels

        Life ->
            case modeId of
                "life_give" ->
                    "This spell gives actual life to a normally inanimate object, plant, or animal, granting it a soul, personality, and humanlike sentience. To succeed, the caster must make a Will save (DC 10 + the target's Hit Dice, or the Hit Dice a plant will have once it comes to life). The newly living creature is friendly toward the caster and speaks one language the caster knows, plus one additional language per point of Intelligence bonus."
                _ ->
                    let decades = qty "life_extra_decade"
                        yearLimit = 200 + decades * 10
                    in
                    "This spell restores life and complete vigor to any deceased creature, provided it has not been dead for more than " ++ String.fromInt yearLimit ++ " years. The condition of the remains is not a factor—so long as some portion of the creature's body still exists, it can be returned to life. The subject is restored to full hit points with no loss of prepared spells, but loses one level (or 1 Constitution if 1st level). This spell cannot revive those who died of old age."

        Reflect ->
            case modeId of
                "reflect_ranged" ->
                    let attacks = 5 + qty "reflect_ranged_extra"
                    in
                    "This spell automatically reflects the next " ++ String.fromInt attacks ++ " ranged attacks made against the caster back on their originators, using the original attack rolls. Once all attacks are reflected, the protection is expended."
                "reflect_melee" ->
                    let attacks = 5 + qty "reflect_melee_extra"
                    in
                    "This spell automatically reflects the next " ++ String.fromInt attacks ++ " melee attacks made against the caster back on their originators, using the original attack rolls. Once all attacks are reflected, the protection is expended."
                _ ->
                    let levelCap = qty "reflect_spell_level"
                        aoe = if has "reflect_aoe" then " It can also reflect area spells that catch the caster in their vicinity." else ""
                        capStr = if levelCap > 0 then String.fromInt (1 + levelCap) else "1"
                    in
                    "This spell returns all spell effects of up to " ++ capStr ++ "th level directed at the caster back on their casters. A single successful reflection expends the protection. Against epic spells, an opposed caster level check is required; if the enemy wins, the protection is suppressed rather than expended." ++ aoe

        Reveal ->
            case modeId of
                "reveal_truesight" ->
                    "This spell allows the caster to pierce illusions and see things as they really are, to a range of 120 feet. The caster can see through normal and magical darkness, notice secret doors hidden by magic, see the exact locations of creatures under blur or displacement effects, see invisible creatures or objects normally, see through illusions, and see the true form of polymorphed or transmuted things."
                "reveal_language" ->
                    if has "reveal_both_lang" then
                        "This spell allows the caster to both comprehend and speak the written and verbal language of another."
                    else
                        "This spell allows the caster to comprehend the written and verbal language of another."
                _ ->
                    let
                        senseStr = if has "reveal_hear" then "see and hear" else "see"
                        mobile = if has "reveal_mobile" then " The sensor is mobile at a speed of 30 feet." else ""
                        plane = if has "reveal_plane" then " The sensor can be placed on a different plane of existence." else ""
                        cast = if has "reveal_cast_through" then " The caster can cast spells with a range of touch or greater through the sensor, but must maintain line of effect to it at all times." else ""
                        noLoe = if has "reveal_no_loe" then " The line of effect requirement for casting through the sensor is waived." else ""
                    in
                    "This spell creates an invisible sensor at a known location through which the caster can " ++ senseStr ++ " almost as if present there. Distance is not a factor, but the locale must be known to the caster." ++ mobile ++ plane ++ cast ++ noLoe

        Slay ->
            case modeId of
                "slay_enervate" ->
                    let dice = 2 + qty "slay_neg_level"
                    in
                    "This spell suppresses the life force of the target, bestowing " ++ String.fromInt dice ++ "d4 negative levels (or half as many on a successful Fortitude save). If the subject has at least as many negative levels as Hit Dice, it dies."
                _ ->
                    let extraHD = qty "slay_hd"
                        targetStr = if extraHD > 0
                            then "up to " ++ String.fromInt (1 + extraHD) ++ " living creatures of up to 80 Hit Dice each"
                            else "a living creature of up to 80 Hit Dice"
                    in
                    "This spell snuffs out the life force of " ++ targetStr ++ ". The subject is entitled to a Fortitude saving throw to survive the attack. If the save is successful, it instead takes 3d6+20 points of damage."

        Summon ->
            case modeId of
                "summon_unique" ->
                    "This spell summons a specific named individual from anywhere in the multiverse. The caster must know the target's name and some facts about its life, and must overcome any magical protections it possesses, its spell resistance, and it must fail a Will saving throw. The target is under no special compulsion to serve the caster."
                _ ->
                    let crBonus = qty "summon_cr"
                        cr = 1 + crBonus
                        creatureStr = if has "summon_nonoutsider"
                            then "a creature of CR " ++ String.fromInt cr ++ " or less from another monster type or subtype"
                            else "an outsider of CR " ++ String.fromInt cr ++ " or less"
                    in
                    "This spell summons " ++ creatureStr ++ " that appears where the caster designates and attacks the caster's opponents to the best of its ability."

        Transform ->
            let
                specific = if has "transform_specific" then " The target is transformed into the specific likeness of another individual, including that individual's memories and mental abilities." else ""
                incorporeal = if has "transform_incorporeal" then " The transformation involves an incorporeal or gaseous form." else ""
            in
            "This spell changes the subject into another form of creature or object. The transformed subject acquires the physical and natural abilities of its new form while retaining its own memories and mental ability scores. The subject's equipment either melds into the new form or remains, at the caster's option." ++ specific ++ incorporeal

        Transport ->
            case modeId of
                "transport_temporal" ->
                    "This spell temporarily transports the caster into a different time stream for 5 rounds. In a slower time stream, the caster's condition becomes fixed—no force or effect can harm it until the duration expires. In a faster time stream, all other creatures seem frozen while the caster is free to act for 5 rounds of apparent time."
                "transport_temporal_lite" ->
                    "This spell hastens or slows the target for 20 rounds by transporting it to the appropriate time stream."
                _ ->
                    let
                        interplanar = if has "transport_interplanar" then " The destination can be on a different plane of existence." else ""
                        unwilling = if has "transport_unwilling" then " The spell can be used to transport unwilling creatures." else ""
                    in
                    "This spell instantly takes the caster to a designated destination, regardless of distance." ++ interplanar ++ unwilling

        Ward ->
            case modeId of
                "ward_energy" ->
                    let pts = 5 + qty "ward_energy_pts"
                        eType = if String.isEmpty (choice "wardEnergyType") then "the chosen energy type" else choice "wardEnergyType"
                    in
                    "This spell grants the target protection from " ++ eType ++ ". Each round, the spell absorbs the first " ++ String.fromInt pts ++ " points of " ++ eType ++ " damage the target would otherwise take, whether the source is natural or magical. The target's equipment is also protected."
                "ward_creature" ->
                    let cType = if String.isEmpty (choice "wardCreatureType") then "the chosen creature type" else choice "wardCreatureType"
                    in
                    "This spell prevents bodily contact by " ++ cType ++ ". This causes their natural weapon attacks to fail and the creatures to recoil if such attacks require touching the warded creature."
                "ward_magic" ->
                    let lvl = 1 + qty "ward_magic_level"
                    in
                    "This spell creates an immobile, faintly shimmering magical sphere with a 10-foot radius that excludes all spell effects of up to " ++ String.fromInt lvl ++ "th level. Any type of spell can still be cast through or out of the ward."
                _ ->
                    let pts = 5 + qty "ward_dmg_pts"
                        typesStr = if has "ward_all_three" then "all three damage types (bludgeoning, piercing, and slashing)" else "two of the three damage types (bludgeoning, piercing, or slashing)"
                    in
                    "This spell protects the target from " ++ typesStr ++ ". Each round, the spell absorbs the first " ++ String.fromInt pts ++ " points of damage the target would otherwise take from those types, whether the source is natural or magical."


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


-- Joins a list of clauses with commas and Oxford "and".
joinClauses : List String -> String
joinClauses items =
    case items of
        [] ->
            ""

        [ x ] ->
            x

        [ x, y ] ->
            x ++ " and " ++ y

        _ ->
            let
                allButLast =
                    List.take (List.length items - 1) items

                lastItem =
                    items |> List.reverse |> List.head |> Maybe.withDefault ""
            in
            String.join ", " allButLast ++ ", and " ++ lastItem


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

generateMarkdown : String -> List SeedInstance -> List AppliedFactor -> String -> Int -> Maybe SeedInstanceId -> String
generateMarkdown spellName instances globalFactors description casterSaveDCBonus maybePrimaryId =
    let
        breakdown =
            calculateBreakdown instances globalFactors

        costs =
            devCosts breakdown.finalDC

        sb =
            statBlock instances globalFactors casterSaveDCBonus maybePrimaryId Nothing Nothing

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
        ++ (sb.target |> Maybe.map (\t -> "**Target:** " ++ t ++ "  \n") |> Maybe.withDefault "")
        ++ (sb.area |> Maybe.map (\a -> "**Area:** " ++ a ++ "  \n") |> Maybe.withDefault "")
        ++ (sb.effect |> Maybe.map (\e -> "**Effect:** " ++ e ++ "  \n") |> Maybe.withDefault "")
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
