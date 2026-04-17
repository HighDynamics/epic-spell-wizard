module Calc exposing (StatBlockData, availableSchools, availableSavingThrows, calculateBreakdown, devCosts, isFactorDisabled, statBlock)

import Dict exposing (Dict)
import Factors exposing (getFactor)
import Seeds exposing (getSeed)
import Types exposing (..)



-- ─── DC Breakdown ─────────────────────────────────────────────────────────────


isFactorDisabled : FactorId -> List AppliedFactor -> Bool
isFactorDisabled factorId appliedFactors =
    case factorId of
        ReduceCastTime1Round ->
            List.any (\af -> af.factorId == IncreaseCastTime1Day) appliedFactors
                || List.any (\af -> af.factorId == OneActionCastTime || af.factorId == QuickenedSpell) appliedFactors

        _ ->
            False


filterEnabledFactors : List AppliedFactor -> List AppliedFactor
filterEnabledFactors appliedFactors =
    List.filter (\af -> not (isFactorDisabled af.factorId appliedFactors)) appliedFactors


calculateBreakdown : List SeedInstance -> List AppliedFactor -> DcBreakdown
calculateBreakdown instances rawFactors =
    let
        globalFactors =
            filterEnabledFactors rawFactors

        seedsTotal =
            instances
                |> List.map effectiveSeedBaseDC
                |> List.sum

        seedFactorsTotal =
            instances
                |> List.map seedInstanceFactorDC
                |> List.sum

        augmentingTotal =
            globalFactors
                |> List.filterMap
                    (\af ->
                        getFactor af.factorId
                            |> Maybe.andThen
                                (\f ->
                                    if f.category == Augmenting && f.kind /= DcMultiplier then
                                        Just (f.dcModifier * af.quantity)

                                    else
                                        Nothing
                                )
                    )
                |> List.sum

        subtotal =
            seedsTotal + seedFactorsTotal + augmentingTotal

        permanentMult =
            if List.any (\af -> af.factorId == PermanentDuration) globalFactors then
                5

            else
                1

        stoneTabletMult =
            if List.any (\af -> af.factorId == StoneTablet) globalFactors then
                2

            else
                1

        mitigatingTotal =
            globalFactors
                |> List.filterMap
                    (\af ->
                        getFactor af.factorId
                            |> Maybe.andThen
                                (\f ->
                                    if f.category == Mitigating then
                                        Just (f.dcModifier * af.quantity)

                                    else
                                        Nothing
                                )
                    )
                |> List.sum

        finalDC =
            max 1 (subtotal * permanentMult * stoneTabletMult + mitigatingTotal)
    in
    { seedsTotal = seedsTotal
    , seedFactorsTotal = seedFactorsTotal
    , augmentingTotal = augmentingTotal
    , permanentMultiplier = permanentMult
    , stoneTabletMultiplier = stoneTabletMult
    , mitigatingTotal = mitigatingTotal
    , finalDC = finalDC
    }



-- The effective base DC for a seed instance, accounting for mode overrides
-- and the Foresee "×2 per interval" special case.


effectiveSeedBaseDC : SeedInstance -> Int
effectiveSeedBaseDC inst =
    case getSeed inst.seedId of
        Nothing ->
            0

        Just seed ->
            let
                modeBaseDC =
                    inst.selectedMode
                        |> Maybe.andThen
                            (\mId ->
                                List.head (List.filter (\m -> m.id == mId) seed.modes)
                                    |> Maybe.andThen .baseDCOverride
                            )

                baseDC =
                    Maybe.withDefault seed.baseDC modeBaseDC
            in
            -- Special case: Foresee "predict" mode — each foresee_interval factor
            -- doubles the seed DC (not additive).
            if inst.seedId == Foresee && inst.selectedMode == Just "foresee_predict" then
                let
                    intervals =
                        inst.appliedSeedFactors
                            |> List.filter (\asf -> asf.factorId == "foresee_interval")
                            |> List.map .quantity
                            |> List.sum
                in
                baseDC * (2 ^ intervals)
                -- Special case: Reveal sensor mode — "no_loe" factor multiplies seed DC by ×10.

            else if inst.seedId == Reveal && inst.selectedMode == Just "reveal_sensor" then
                let
                    noLoe =
                        List.any (\asf -> asf.factorId == "reveal_no_loe" && asf.quantity > 0)
                            inst.appliedSeedFactors
                in
                if noLoe then
                    baseDC * 10

                else
                    baseDC

            else
                baseDC



-- Sum additive seed-specific factors for one instance.
-- Foresee intervals and Reveal no_loe are handled in effectiveSeedBaseDC, not here.


seedInstanceFactorDC : SeedInstance -> Int
seedInstanceFactorDC inst =
    case getSeed inst.seedId of
        Nothing ->
            0

        Just seed ->
            let
                activeModeFactors =
                    inst.selectedMode
                        |> Maybe.andThen
                            (\mId ->
                                List.head (List.filter (\m -> m.id == mId) seed.modes)
                                    |> Maybe.map .factors
                            )
                        |> Maybe.withDefault []

                availableFactors =
                    seed.universalFactors ++ activeModeFactors

                -- Skip factors whose DC is already handled via seed base DC multiplication
                skipIds =
                    [ "foresee_interval", "reveal_no_loe" ]
            in
            inst.appliedSeedFactors
                |> List.filterMap
                    (\asf ->
                        if List.member asf.factorId skipIds then
                            Nothing

                        else
                            List.head (List.filter (\sf -> sf.id == asf.factorId) availableFactors)
                                |> Maybe.map (\sf -> sf.dcModifier * asf.quantity)
                    )
                |> List.sum



-- ─── Development Costs ────────────────────────────────────────────────────────


devCosts : Int -> DevCosts
devCosts finalDC =
    let
        gold =
            9000 * finalDC

        timeDays =
            ceiling (toFloat gold / 50000)

        xp =
            gold // 25
    in
    { goldCost = gold
    , timeDays = timeDays
    , xpCost = xp
    }



-- ─── Live Stat Block ──────────────────────────────────────────────────────────
-- Derives each stat block field from seeds + global factors.


type alias StatBlockData =
    { school : String
    , descriptors : List String
    , components : List String
    , castingTime : String
    , range : String
    , targetAreaEffect : String
    , duration : String
    , savingThrow : String -- fully formatted, e.g. "Will negates (DC 26)"
    , spellResistance : String
    }


availableSchools : List SeedInstance -> List String
availableSchools instances =
    instances
        |> List.filterMap (\inst -> getSeed inst.seedId |> Maybe.map .school)
        |> List.foldl (\s acc -> if List.member s acc then acc else acc ++ [ s ]) []


availableSavingThrows : List SeedInstance -> List SavingThrow
availableSavingThrows instances =
    instances
        |> List.filterMap (\inst -> getSeed inst.seedId |> Maybe.andThen .savingThrow)
        |> List.foldl
            (\st acc ->
                if List.any (\s -> s.saveType == st.saveType) acc then
                    acc

                else
                    acc ++ [ st ]
            )
            []


statBlock : List SeedInstance -> List AppliedFactor -> Int -> Maybe SeedInstanceId -> Maybe String -> Maybe SavingThrow -> StatBlockData
statBlock instances rawFactors saveDCBonus maybePrimaryId maybeSchool maybeSavingThrow =
    let
        globalFactors =
            filterEnabledFactors rawFactors

        seeds =
            List.filterMap (\inst -> getSeed inst.seedId) instances

        primarySeed =
            let
                found =
                    maybePrimaryId
                        |> Maybe.andThen
                            (\iid ->
                                List.filter (\i -> i.instanceId == iid) instances
                                    |> List.head
                                    |> Maybe.andThen (\i -> getSeed i.seedId)
                            )
            in
            case found of
                Just _ ->
                    found

                Nothing ->
                    List.head seeds

        school =
            maybeSchool
                |> Maybe.withDefault
                    (availableSchools instances |> List.head |> Maybe.withDefault "—")

        descriptors =
            seeds
                |> List.concatMap .descriptors
                |> List.foldl
                    (\d acc ->
                        if List.member d acc then
                            acc

                        else
                            acc ++ [ d ]
                    )
                    []

        baseComponents =
            seeds
                |> List.concatMap .components
                |> List.foldl
                    (\c acc ->
                        if List.member c acc then
                            acc

                        else
                            acc ++ [ c ]
                    )
                    []

        removeV =
            List.any (\af -> af.factorId == NoVerbal) globalFactors

        removeS =
            List.any (\af -> af.factorId == NoSomatic) globalFactors

        components =
            baseComponents
                |> List.filter (\c -> not (removeV && c == V))
                |> List.filter (\c -> not (removeS && c == S))
                |> List.map componentToString

        castingTime =
            deriveCastingTime globalFactors primarySeed

        range =
            deriveRange globalFactors primarySeed

        targetAreaEffect =
            Maybe.map .targetAreaEffect primarySeed |> Maybe.withDefault "—"

        duration =
            deriveDuration globalFactors instances

        resolvedSave =
            case maybeSavingThrow of
                Just _ ->
                    maybeSavingThrow

                Nothing ->
                    availableSavingThrows instances |> List.head

        savingThrow =
            deriveSavingThrow resolvedSave globalFactors saveDCBonus

        spellResistance =
            if List.any .spellResistance seeds then
                "Yes"

            else
                "No"
    in
    { school = school
    , descriptors = descriptors
    , components = components
    , castingTime = castingTime
    , range = range
    , targetAreaEffect = targetAreaEffect
    , duration = duration
    , savingThrow = savingThrow
    , spellResistance = spellResistance
    }


componentToString : Component -> String
componentToString c =
    case c of
        V ->
            "V"

        S ->
            "S"

        M ->
            "M"

        DF ->
            "DF"

        F ->
            "F"

        XP ->
            "XP"


deriveCastingTime : List AppliedFactor -> Maybe Seed -> String
deriveCastingTime globalFactors primarySeed =
    let
        base =
            Maybe.map .castingTime primarySeed |> Maybe.withDefault "1 minute"
    in
    if List.any (\af -> af.factorId == QuickenedSpell) globalFactors then
        "Free action (quickened)"

    else if List.any (\af -> af.factorId == OneActionCastTime) globalFactors then
        "1 action"

    else
        let
            minExtra =
                globalFactors
                    |> List.filter (\af -> af.factorId == IncreaseCastTime1Min)
                    |> List.map .quantity
                    |> List.sum

            dayExtra =
                globalFactors
                    |> List.filter (\af -> af.factorId == IncreaseCastTime1Day)
                    |> List.map .quantity
                    |> List.sum

            roundReductions =
                globalFactors
                    |> List.filter (\af -> af.factorId == ReduceCastTime1Round)
                    |> List.map .quantity
                    |> List.sum
        in
        if dayExtra > 0 then
            String.fromInt (10 + dayExtra) ++ " minutes + " ++ String.fromInt dayExtra ++ " day(s)"

        else if roundReductions > 0 then
            let
                totalRounds =
                    (1 + minExtra) * 10

                afterRounds =
                    max (totalRounds - roundReductions) 1

                resultMinutes =
                    afterRounds // 10

                resultRounds =
                    modBy 10 afterRounds

                minutesStr n =
                    String.fromInt n ++ (if n == 1 then " minute" else " minutes")

                roundsStr n =
                    String.fromInt n ++ (if n == 1 then " round" else " rounds")
            in
            if resultMinutes > 0 && resultRounds > 0 then
                minutesStr resultMinutes ++ " + " ++ roundsStr resultRounds

            else if resultMinutes > 0 then
                minutesStr resultMinutes

            else
                roundsStr resultRounds

        else if minExtra > 0 then
            String.fromInt (1 + minExtra) ++ " minutes"

        else
            base


deriveRange : List AppliedFactor -> Maybe Seed -> String
deriveRange globalFactors primarySeed =
    let
        base =
            Maybe.map .range primarySeed |> Maybe.withDefault "—"

        doublings =
            globalFactors
                |> List.filter (\af -> af.factorId == IncreaseRange)
                |> List.map .quantity
                |> List.sum
    in
    if doublings > 0 then
        base ++ " (×" ++ String.fromInt (2 ^ doublings) ++ ")"

    else
        base



-- Ranks a duration string from shortest (0) to longest.
-- Lower rank = shorter duration = this seed wins when multiple seeds are active.
-- Tune these ranks to match the game rules.


durationRank : String -> Int
durationRank d =
    case d of
        "5 rounds" ->
            5

        "20 rounds" ->
            10

        "20 rounds (D)" ->
            11

        "Concentration + 20 minutes" ->
            20

        "20 minutes" ->
            30

        "200 minutes" ->
            40

        "200 minutes (D)" ->
            41

        "200 minutes or until expended (D)" ->
            42

        "8 hours (simple objects last 24 hours)" ->
            50

        "Until expended (up to 12 hours)" ->
            55

        "20 hours" ->
            60

        "20 hours or until completed" ->
            61

        "24 hours (D)" ->
            65

        "Concentration + 20 hours" ->
            70

        _ ->
            99



-- Returns the effective duration string for a single instance.
-- Accounts for mode-specific overrides once those exist; for now falls back to
-- the seed's base duration.


instanceDuration : SeedInstance -> String
instanceDuration inst =
    case getSeed inst.seedId of
        Nothing ->
            "—"

        Just seed ->
            inst.selectedMode
                |> Maybe.andThen (\modeId -> List.filter (.id >> (==) modeId) seed.modes |> List.head)
                |> Maybe.andThen .durationOverride
                |> Maybe.withDefault seed.duration


deriveDuration : List AppliedFactor -> List SeedInstance -> String
deriveDuration globalFactors instances =
    let
        base =
            instances
                |> List.map instanceDuration
                |> List.sortBy durationRank
                |> List.head
                |> Maybe.withDefault "—"

        isPermanent =
            List.any (\af -> af.factorId == PermanentDuration) globalFactors

        doublings =
            globalFactors
                |> List.filter (\af -> af.factorId == IncreaseDuration)
                |> List.map .quantity
                |> List.sum
    in
    if isPermanent then
        "Permanent"

    else if doublings > 0 then
        base ++ " (×" ++ String.fromInt (2 ^ doublings) ++ ")"

    else
        base


deriveSavingThrow : Maybe SavingThrow -> List AppliedFactor -> Int -> String
deriveSavingThrow mst globalFactors saveDCBonus =
    case mst of
        Nothing ->
            "None"

        Just st ->
            let
                typeStr =
                    case st.saveType of
                        WillSave ->
                            "Will"

                        ReflexSave ->
                            "Reflex"

                        FortSave ->
                            "Fortitude"

                effectStr =
                    case st.effect of
                        Negates ->
                            "negates"

                        Half ->
                            "half"

                        Partial ->
                            "partial"

                        SeeText ->
                            "(see text)"

                harmlessStr =
                    if st.harmless then
                        " (harmless)"

                    else
                        ""

                dcBonusFromFactors =
                    globalFactors
                        |> List.filter (\af -> af.factorId == IncreaseSaveDC)
                        |> List.map .quantity
                        |> List.sum

                totalBonus =
                    saveDCBonus + dcBonusFromFactors

                dcStr =
                    if totalBonus > 0 then
                        " (DC " ++ String.fromInt (20 + totalBonus) ++ ")"

                    else
                        ""
            in
            typeStr ++ " " ++ effectStr ++ dcStr ++ harmlessStr
