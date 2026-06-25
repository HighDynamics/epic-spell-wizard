module Export exposing (generateDescription, generateMarkdown)

import Calc exposing (calculateBreakdown, devCosts, statBlock)
import Factors exposing (getFactor)
import Seeds exposing (getSeed)
import Types exposing (..)


-- ─── Description generation ───────────────────────────────────────────────────

generateDescription : List SeedInstance -> List AppliedFactor -> String
generateDescription instances globalFactors =
    let
        paragraphs =
            instances |> List.filterMap (\inst -> getSeed inst.seedId |> Maybe.map .description)

        additionalProps =
            buildAdditionalProps globalFactors
    in
    String.join "\n\n" paragraphs
        ++ (if String.isEmpty additionalProps then "" else "\n\n" ++ additionalProps)


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

generateMarkdown : String -> List SeedInstance -> List AppliedFactor -> String -> Int -> Maybe SeedInstanceId -> Maybe String -> Maybe String -> String
generateMarkdown spellName instances globalFactors description casterSaveDCBonus maybePrimaryId maybeTargetToAreaShape maybePersonalToAreaShape =
    let
        breakdown =
            calculateBreakdown instances globalFactors

        costs =
            devCosts breakdown.finalDC

        sb =
            statBlock instances globalFactors casterSaveDCBonus maybePrimaryId Nothing Nothing maybeTargetToAreaShape maybePersonalToAreaShape

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
