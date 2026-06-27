module Calc exposing (StatBlockData, availableSchools, availableSavingThrows, boltShapes, calculateBreakdown, devCosts, seedInstanceLabels, sortByName, statBlock, targetToAreaShapes, targetToAreaText)

import Dict exposing (Dict)
import Factors exposing (getFactor)
import Seeds exposing (getSeed)
import Types exposing (..)



-- ─── DC Breakdown ─────────────────────────────────────────────────────────────


calculateBreakdown : List SeedInstance -> List AppliedFactor -> DcBreakdown
calculateBreakdown instances rawFactors =
    let
        globalFactors =
            rawFactors

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
                baseDC =
                    Maybe.withDefault seed.baseDC inst.baseDCOverride
            in
            -- Special case: Foresee — each foresee_interval factor
            -- doubles the seed DC (not additive).
            if inst.seedId == Foresee then
                let
                    intervals =
                        inst.appliedSeedFactors
                            |> List.filter (\asf -> asf.factorId == "foresee_interval")
                            |> List.map .quantity
                            |> List.sum
                in
                baseDC * (2 ^ intervals)
                -- Special case: Reveal — "no_loe" factor multiplies seed DC by ×10.

            else if inst.seedId == Reveal then
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
                availableFactors =
                    seed.universalFactors ++ List.concatMap .factors seed.modes

                -- Skip factors whose DC is already handled via seed base DC multiplication
                skipIds =
                    [ "foresee_interval", "reveal_no_loe" ]

                factorTotal =
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

                -- Choices (e.g. Animate Dead's "Undead Type") may carry a
                -- per-option DC modifier instead of using a seed factor.
                choiceTotal =
                    seed.choices
                        |> List.filterMap
                            (\choice ->
                                if List.isEmpty choice.dcModifiers then
                                    Nothing

                                else
                                    let
                                        selected =
                                            Dict.get choice.id inst.choices |> Maybe.withDefault choice.default
                                    in
                                    choice.dcModifiers
                                        |> List.filter (\( opt, _ ) -> opt == selected)
                                        |> List.head
                                        |> Maybe.map Tuple.second
                            )
                        |> List.sum
            in
            factorTotal + choiceTotal



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



-- ─── Target → Area shape options ─────────────────────────────────────────────


targetToAreaShapes : List String
targetToAreaShapes =
    [ "Bolt (5 ft. × 300 ft.)"
    , "Bolt (10 ft. × 150 ft.)"
    , "Cylinder"
    , "40-ft. cone"
    , "Four 10-ft. cubes"
    , "20-ft. radius"
    ]


boltShapes : List String
boltShapes =
    [ "Bolt (5 ft. × 300 ft.)"
    , "Bolt (10 ft. × 150 ft.)"
    ]


targetToAreaText : String -> String
targetToAreaText label =
    case label of
        "Cylinder" ->
            "Cylinder (10-ft. radius, 30 ft. high)"

        "20-ft. radius" ->
            "20-ft.-radius spread"

        _ ->
            label



-- ─── Live Stat Block ──────────────────────────────────────────────────────────
-- Derives each stat block field from seeds + global factors.


type alias StatBlockData =
    { school : String
    , descriptors : List String
    , components : List String
    , castingTime : String
    , range : String
    , target : Maybe String
    , area : Maybe String
    , effect : Maybe String
    , duration : String
    , savingThrow : String -- fully formatted, e.g. "Will negates (DC 26)"
    , spellResistance : String
    }


-- Orders seed instances alphabetically by their seed's name. Stable, so
-- duplicate instances of the same seed keep their original relative order.
sortByName : List SeedInstance -> List SeedInstance
sortByName instances =
    instances
        |> List.sortBy (\inst -> getSeed inst.seedId |> Maybe.map .name |> Maybe.withDefault "")


availableSchools : List SeedInstance -> List String
availableSchools instances =
    instances
        |> List.filterMap (\inst -> getSeed inst.seedId |> Maybe.map .school)
        |> List.foldl (\s acc -> if List.member s acc then acc else acc ++ [ s ]) []


-- Labels duplicate seeds the same way across the Factors panel and the
-- Summary panel's Seed Factors section: "Afflict", "Afflict (2)", "Afflict (3)", ...
seedInstanceLabels : List SeedInstance -> Dict SeedInstanceId String
seedInstanceLabels instances =
    instances
        |> List.foldl
            (\inst ( seenCounts, acc ) ->
                case getSeed inst.seedId of
                    Nothing ->
                        ( seenCounts, acc )

                    Just seed ->
                        let
                            priorCount =
                                Dict.get seed.name seenCounts |> Maybe.withDefault 0

                            label =
                                if priorCount == 0 then
                                    seed.name

                                else
                                    seed.name ++ " (" ++ String.fromInt (priorCount + 1) ++ ")"
                        in
                        ( Dict.insert seed.name (priorCount + 1) seenCounts
                        , Dict.insert inst.instanceId label acc
                        )
            )
            ( Dict.empty, Dict.empty )
        |> Tuple.second


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


statBlock : List SeedInstance -> List AppliedFactor -> Int -> Maybe SeedInstanceId -> Maybe String -> Maybe SavingThrow -> Maybe String -> Maybe String -> Maybe String -> StatBlockData
statBlock instances rawFactors saveDCBonus maybePrimaryId maybeSchool maybeSavingThrow maybeTargetToAreaShape maybePersonalToAreaShape maybeBoltShape =
    let
        globalFactors =
            rawFactors

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

        targetToTouchActive =
            List.any (\af -> af.factorId == TargetToTouch) globalFactors

        areaToTouchActive =
            List.any (\af -> af.factorId == AreaToTouch) globalFactors

        areaToTargetActive =
            List.any (\af -> af.factorId == AreaToTarget) globalFactors

        changeToPersonalActive =
            List.any (\af -> af.factorId == ChangeToPersonal) globalFactors

        castingTime =
            deriveCastingTime globalFactors primarySeed

        rangeBase =
            if targetToTouchActive then
                "300 ft."

            else if areaToTouchActive then
                "25 ft. + 5 ft./2 levels"

            else
                Maybe.map .range primarySeed |> Maybe.withDefault "—"

        range =
            if changeToPersonalActive then
                "Personal"

            else
                deriveRange globalFactors rangeBase

        targetToAreaActive =
            List.any (\af -> af.factorId == TargetToArea) globalFactors

        personalToAreaActive =
            List.any (\af -> af.factorId == PersonalToArea) globalFactors

        activeToAreaShape =
            if targetToAreaActive then
                maybeTargetToAreaShape

            else if personalToAreaActive then
                maybePersonalToAreaShape

            else
                Nothing

        convertingToArea =
            targetToAreaActive || personalToAreaActive

        -- "Change area to ..." factors set a fixed Area text directly,
        -- independent of the Target/Personal -> Area conversion picker.
        areaChangeText =
            if List.any (\af -> af.factorId == ChangeToBolt) globalFactors then
                Just (Maybe.withDefault (List.head boltShapes |> Maybe.withDefault "") maybeBoltShape)

            else if List.any (\af -> af.factorId == ChangeToCylinder) globalFactors then
                Just (targetToAreaText "Cylinder")

            else if List.any (\af -> af.factorId == ChangeToCone) globalFactors then
                Just (targetToAreaText "40-ft. cone")

            else if List.any (\af -> af.factorId == ChangeToFourCubes) globalFactors then
                Just (targetToAreaText "Four 10-ft. cubes")

            else if List.any (\af -> af.factorId == ChangeToRadius) globalFactors then
                Just (targetToAreaText "20-ft. radius")

            else
                Nothing

        increaseAreaCount =
            globalFactors
                |> List.filter (\af -> af.factorId == IncreaseArea)
                |> List.map .quantity
                |> List.sum

        extraTargets =
            globalFactors
                |> List.filter (\af -> af.factorId == AddExtraTarget)
                |> List.head
                |> Maybe.map .quantity
                |> Maybe.withDefault 0

        target =
            if changeToPersonalActive then
                Just "You"

            else if areaToTargetActive then
                Just "TBD"

            else if convertingToArea then
                Nothing

            else
                primarySeed
                    |> Maybe.andThen .target
                    |> Maybe.map
                        (\t ->
                            if extraTargets > 0 then
                                t ++ " (+" ++ String.fromInt extraTargets ++ " additional " ++ (if extraTargets == 1 then "target" else "targets") ++ ")"

                            else
                                t
                        )

        areaBeforeIncrease =
            if changeToPersonalActive || areaToTargetActive || areaToTouchActive then
                Nothing

            else if convertingToArea then
                activeToAreaShape |> Maybe.map targetToAreaText

            else
                case areaChangeText of
                    Just t ->
                        Just t

                    Nothing ->
                        Maybe.andThen .area primarySeed

        area =
            if increaseAreaCount > 0 then
                Maybe.map (scaleNumbers (increaseAreaCount + 1)) areaBeforeIncrease

            else
                areaBeforeIncrease

        effect =
            if targetToTouchActive || areaToTouchActive then
                Just "Ray"

            else
                Maybe.andThen .effect primarySeed

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
    , target = target
    , area = area
    , effect = effect
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

            minutesStr n =
                String.fromInt n ++ (if n == 1 then " minute" else " minutes")

            daysStr n =
                String.fromInt n ++ (if n == 1 then " day" else " days")
        in
        if dayExtra > 0 then
            minutesStr (1 + minExtra) ++ " + " ++ daysStr dayExtra

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


formatLargeInt : Int -> String
formatLargeInt n =
    if n >= 1000 then
        formatLargeInt (n // 1000) ++ "," ++ String.padLeft 3 '0' (String.fromInt (modBy 1000 n))

    else
        String.fromInt n


-- Scale only distance values (numbers followed by " ft.") in a range string.
-- Comma-formatted thousands ("12,000 ft.") are handled as a unit.
-- Non-distance numbers like weights ("2,000 lb.") are passed through unchanged.
scaleRange : Int -> String -> String
scaleRange mult s =
    case String.uncons s of
        Nothing ->
            ""

        Just ( c, rest ) ->
            if Char.isDigit c then
                let
                    ( digits, afterDigits ) =
                        leadingDigits s

                    -- Absorb a comma-thousands group if it precedes " ft."
                    ( fullNumStr, remaining ) =
                        if String.startsWith "," afterDigits then
                            let
                                commaTail =
                                    String.dropLeft 1 afterDigits

                                ( extraDigits, afterExtra ) =
                                    leadingDigits commaTail
                            in
                            if String.length extraDigits == 3 && String.startsWith " ft." afterExtra then
                                ( digits ++ "," ++ extraDigits, afterExtra )

                            else
                                ( digits, afterDigits )

                        else
                            ( digits, afterDigits )
                in
                if String.startsWith " ft." remaining then
                    case String.toInt (String.replace "," "" fullNumStr) of
                        Nothing ->
                            fullNumStr ++ scaleRange mult remaining

                        Just n ->
                            formatLargeInt (n * mult) ++ scaleRange mult remaining

                else
                    fullNumStr ++ scaleRange mult remaining

            else
                String.fromChar c ++ scaleRange mult rest


deriveRange : List AppliedFactor -> String -> String
deriveRange globalFactors base =
    let
        doublings =
            globalFactors
                |> List.filter (\af -> af.factorId == IncreaseRange)
                |> List.map .quantity
                |> List.sum
    in
    if doublings > 0 then
        scaleRange (doublings + 1) base

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



-- Returns the duration string for a single instance.


instanceDuration : SeedInstance -> String
instanceDuration inst =
    case getSeed inst.seedId of
        Nothing ->
            "—"

        Just seed ->
            seed.duration


-- Extract the leading run of digit characters from a string.
leadingDigits : String -> ( String, String )
leadingDigits s =
    case String.uncons s of
        Nothing ->
            ( "", "" )

        Just ( c, rest ) ->
            if Char.isDigit c then
                let
                    ( moreDigits, remaining ) =
                        leadingDigits rest
                in
                ( String.fromChar c ++ moreDigits, remaining )

            else
                ( "", s )


-- Scale every number in a string by `mult`.
-- Each application of a "increase X 100%" factor adds one more base value,
-- so n applications → multiplier of (n + 1).
-- Walks the full string so multiple numeric values (e.g. Conjure's
-- "8 hours (simple objects last 24 hours)") are all scaled.
scaleNumbers : Int -> String -> String
scaleNumbers mult s =
    case String.uncons s of
        Nothing ->
            ""

        Just ( c, rest ) ->
            if Char.isDigit c then
                let
                    ( digits, remaining ) =
                        leadingDigits s
                in
                case String.toInt digits of
                    Nothing ->
                        digits ++ scaleNumbers mult remaining

                    Just n ->
                        String.fromInt (n * mult) ++ scaleNumbers mult remaining

            else
                String.fromChar c ++ scaleNumbers mult rest


scaleDuration : Int -> String -> String
scaleDuration mult s =
    scaleNumbers mult s


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

        isDismissable =
            List.any (\af -> af.factorId == Dismissible) globalFactors
                || List.any (instanceDuration >> String.contains "(D)") instances

        addDismissTag s =
            if isDismissable && not (String.contains "(D)" s) then
                s ++ " (D)"

            else
                s
    in
    if isPermanent then
        addDismissTag "Permanent"

    else if doublings > 0 then
        addDismissTag (scaleDuration (doublings + 1) base)

    else
        addDismissTag base


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
                        " (DC +" ++ String.fromInt totalBonus ++ ")"

                    else
                        ""
            in
            typeStr ++ " " ++ effectStr ++ dcStr ++ harmlessStr
