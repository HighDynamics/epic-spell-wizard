module Export exposing (generateMarkdown, generatePlainText)

import Calc exposing (StatBlockData, calculateBreakdown, devCosts, statBlock)
import Dict
import Factors exposing (getFactor)
import Seeds exposing (getSeed)
import Types exposing (..)



-- ─── Shared data gathering ──────────────────────────────────────────────────


uniqueSeeds : List SeedInstance -> List Seed
uniqueSeeds instances =
    instances
        |> List.filterMap (\inst -> getSeed inst.seedId)
        |> List.foldl
            (\seed acc ->
                if List.any (\s -> s.id == seed.id) acc then
                    acc

                else
                    acc ++ [ seed ]
            )
            []


statBlockRows : Int -> StatBlockData -> List ( String, String )
statBlockRows finalDC sb =
    let
        descriptorStr =
            if List.isEmpty sb.descriptors then
                ""

            else
                " [" ++ String.join ", " sb.descriptors ++ "]"
    in
    [ ( "School", sb.school ++ descriptorStr )
    , ( "Spellcraft DC", String.fromInt finalDC )
    , ( "Components", String.join ", " sb.components )
    , ( "Casting Time", sb.castingTime )
    , ( "Range", sb.range )
    ]
        ++ List.filterMap identity
            [ Maybe.map (\t -> ( "Target", t )) sb.target
            , Maybe.map (\a -> ( "Area", a )) sb.area
            , Maybe.map (\e -> ( "Effect", e )) sb.effect
            ]
        ++ [ ( "Duration", sb.duration )
           , ( "Saving Throw", sb.savingThrow )
           , ( "Spell Resistance", sb.spellResistance )
           ]


seedStatBlockRows : Seed -> List ( String, String )
seedStatBlockRows seed =
    let
        descriptorStr =
            if List.isEmpty seed.descriptors then
                ""

            else
                " [" ++ String.join ", " seed.descriptors ++ "]"

        savingThrowStr =
            case seed.savingThrow of
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
                    in
                    typeStr ++ " " ++ effectStr ++ harmlessStr
    in
    [ ( "School", seed.school ++ descriptorStr )
    , ( "Components", String.join ", " (List.map componentToString seed.components) )
    , ( "Casting Time", seed.castingTime )
    , ( "Range", seed.range )
    ]
        ++ List.filterMap identity
            [ Maybe.map (\t -> ( "Target", t )) seed.target
            , Maybe.map (\a -> ( "Area", a )) seed.area
            , Maybe.map (\e -> ( "Effect", e )) seed.effect
            ]
        ++ [ ( "Duration", seed.duration )
           , ( "Saving Throw", savingThrowStr )
           , ( "Spell Resistance"
             , if seed.spellResistance then
                "Yes"

               else
                "No"
             )
           ]


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


factorLine : AppliedFactor -> Maybe String
factorLine af =
    getFactor af.factorId
        |> Maybe.map
            (\f ->
                f.name
                    ++ (if af.quantity > 1 then
                            " ×" ++ String.fromInt af.quantity

                        else
                            ""
                       )
                    ++ (if f.kind == DcMultiplier then
                            " (×" ++ String.fromInt f.multiplierValue ++ ")"

                        else
                            " (" ++ showSign (f.dcModifier * af.quantity) ++ ")"
                       )
            )


globalFactorLines : FactorCategory -> List AppliedFactor -> List String
globalFactorLines category globalFactors =
    globalFactors
        |> List.filter
            (\af ->
                getFactor af.factorId |> Maybe.map (\f -> f.category == category) |> Maybe.withDefault False
            )
        |> List.filterMap factorLine


seedFactorBlocks : List SeedInstance -> List { label : String, lines : List String }
seedFactorBlocks instances =
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

                            choiceLines =
                                seed.choices
                                    |> List.map
                                        (\c ->
                                            c.label
                                                ++ ": "
                                                ++ (Dict.get c.id inst.choices |> Maybe.withDefault c.default)
                                        )

                            overrideLines =
                                case inst.baseDCOverride of
                                    Just dc ->
                                        if dc /= seed.baseDC then
                                            [ "Base DC override: " ++ String.fromInt dc ]

                                        else
                                            []

                                    Nothing ->
                                        []

                            availableFactors =
                                seed.universalFactors ++ List.concatMap .factors seed.modes

                            factorLines =
                                inst.appliedSeedFactors
                                    |> List.filter (\asf -> asf.quantity > 0)
                                    |> List.filterMap
                                        (\asf ->
                                            List.head (List.filter (\sf -> sf.id == asf.factorId) availableFactors)
                                                |> Maybe.map
                                                    (\sf ->
                                                        sf.name
                                                            ++ (if asf.quantity > 1 then
                                                                    " ×" ++ String.fromInt asf.quantity

                                                                else
                                                                    ""
                                                               )
                                                            ++ (if sf.dcModifier == 0 then
                                                                    " (special)"

                                                                else
                                                                    " (" ++ showSign (sf.dcModifier * asf.quantity) ++ ")"
                                                               )
                                                    )
                                        )

                            lines =
                                choiceLines ++ overrideLines ++ factorLines
                        in
                        if List.isEmpty lines then
                            ( Dict.insert seed.name (priorCount + 1) seenCounts, acc )

                        else
                            ( Dict.insert seed.name (priorCount + 1) seenCounts
                            , acc ++ [ { label = label, lines = lines } ]
                            )
            )
            ( Dict.empty, [] )
        |> Tuple.second
        |> List.sortBy .label


resolvePrimaryInstanceId : List SeedInstance -> Maybe SeedInstanceId -> Maybe SeedInstanceId
resolvePrimaryInstanceId instances maybePrimaryId =
    case maybePrimaryId of
        Just pid ->
            if List.any (\i -> i.instanceId == pid) instances then
                Just pid

            else
                List.head instances |> Maybe.map .instanceId

        Nothing ->
            List.head instances |> Maybe.map .instanceId


primarySeedId : List SeedInstance -> Maybe SeedInstanceId -> Maybe SeedId
primarySeedId instances maybePrimaryId =
    resolvePrimaryInstanceId instances maybePrimaryId
        |> Maybe.andThen (\pid -> List.head (List.filter (\i -> i.instanceId == pid) instances))
        |> Maybe.map .seedId


seedListLine : Maybe SeedInstanceId -> List SeedInstance -> String
seedListLine maybePrimaryId instances =
    let
        resolvedPrimaryId =
            resolvePrimaryInstanceId instances maybePrimaryId

        showPrimaryTag =
            List.length instances > 1
    in
    instances
        |> List.filterMap
            (\inst ->
                getSeed inst.seedId
                    |> Maybe.map
                        (\s ->
                            s.name
                                ++ " ("
                                ++ String.fromInt (Maybe.withDefault s.baseDC inst.baseDCOverride)
                                ++ ")"
                                ++ (if showPrimaryTag && resolvedPrimaryId == Just inst.instanceId then
                                        " [Primary]"

                                    else
                                        ""
                                   )
                        )
            )
        |> String.join ", "


showSign : Int -> String
showSign n =
    if n >= 0 then
        "+" ++ String.fromInt n

    else
        String.fromInt n


formatNum : Int -> String
formatNum n =
    let
        str =
            String.fromInt n

        len =
            String.length str
    in
    if len <= 3 then
        str

    else
        formatNum (n // 1000) ++ "," ++ String.padLeft 3 '0' (String.fromInt (modBy 1000 n))



-- ─── Markdown export ──────────────────────────────────────────────────────────


generateMarkdown : String -> List SeedInstance -> List AppliedFactor -> Int -> Maybe SeedInstanceId -> Maybe String -> Maybe String -> String
generateMarkdown spellName instances globalFactors casterSaveDCBonus maybePrimaryId maybeTargetToAreaShape maybePersonalToAreaShape =
    let
        breakdown =
            calculateBreakdown instances globalFactors

        costs =
            devCosts breakdown.finalDC

        sb =
            statBlock instances globalFactors casterSaveDCBonus maybePrimaryId Nothing Nothing maybeTargetToAreaShape maybePersonalToAreaShape

        title =
            if String.isEmpty spellName then
                "Unnamed Spell"

            else
                spellName

        augments =
            globalFactorLines Augmenting globalFactors

        mitigations =
            globalFactorLines Mitigating globalFactors

        seedBlocks =
            seedFactorBlocks instances

        seeds =
            uniqueSeeds instances

        primarySeed =
            primarySeedId instances maybePrimaryId

        mdRows rows =
            rows |> List.map (\( label, val ) -> "**" ++ label ++ ":** " ++ val ++ "  \n") |> String.concat

        bulletList items =
            if List.isEmpty items then
                "_None_\n"

            else
                items |> List.map (\i -> "- " ++ i ++ "\n") |> String.concat
    in
    "# "
        ++ title
        ++ "\n\n"
        ++ "## Stat Block\n\n"
        ++ mdRows (statBlockRows breakdown.finalDC sb)
        ++ "\n"
        ++ "## Seeds Used\n\n"
        ++ seedListLine maybePrimaryId instances
        ++ "\n\n"
        ++ "## DC Breakdown\n\n"
        ++ "| | |\n|---|---|\n"
        ++ "| Seeds | "
        ++ showSign breakdown.seedsTotal
        ++ " |\n"
        ++ "| Seed Factors | "
        ++ showSign breakdown.seedFactorsTotal
        ++ " |\n"
        ++ "| Augmenting | "
        ++ showSign breakdown.augmentingTotal
        ++ " |\n"
        ++ (if breakdown.permanentMultiplier > 1 then
                "| Permanent Duration | ×5 |\n"

            else
                ""
           )
        ++ (if breakdown.stoneTabletMultiplier > 1 then
                "| Stone Tablet | ×2 |\n"

            else
                ""
           )
        ++ "| Mitigating | "
        ++ showSign breakdown.mitigatingTotal
        ++ " |\n"
        ++ "| **Final DC** | **"
        ++ String.fromInt breakdown.finalDC
        ++ "** |\n\n"
        ++ "## Development Costs\n\n"
        ++ "| | |\n|---|---|\n"
        ++ "| Gold Cost | "
        ++ formatNum costs.goldCost
        ++ " gp |\n"
        ++ "| Development Time | "
        ++ String.fromInt costs.timeDays
        ++ " days |\n"
        ++ "| XP Cost | "
        ++ formatNum costs.xpCost
        ++ " XP |\n\n"
        ++ "## Seed Factors\n\n"
        ++ (if List.isEmpty seedBlocks then
                "_None_\n\n"

            else
                seedBlocks
                    |> List.map (\b -> "**" ++ b.label ++ "**\n\n" ++ bulletList b.lines ++ "\n")
                    |> String.concat
           )
        ++ "## Global Augments\n\n"
        ++ bulletList augments
        ++ "\n"
        ++ "## Global Mitigations\n\n"
        ++ bulletList mitigations
        ++ "\n"
        ++ "## Original Seed Listing\n\n"
        ++ (seeds
                |> List.map
                    (\seed ->
                        "### "
                            ++ seed.name
                            ++ (if List.length seeds > 1 && primarySeed == Just seed.id then
                                    " (Primary)"

                                else
                                    ""
                               )
                            ++ "\n\n"
                            ++ mdRows (seedStatBlockRows seed)
                            ++ "\n"
                            ++ seed.description
                            ++ "\n\n"
                    )
                |> String.concat
           )



-- ─── Plain text export ────────────────────────────────────────────────────────


generatePlainText : String -> List SeedInstance -> List AppliedFactor -> Int -> Maybe SeedInstanceId -> Maybe String -> Maybe String -> String
generatePlainText spellName instances globalFactors casterSaveDCBonus maybePrimaryId maybeTargetToAreaShape maybePersonalToAreaShape =
    let
        breakdown =
            calculateBreakdown instances globalFactors

        costs =
            devCosts breakdown.finalDC

        sb =
            statBlock instances globalFactors casterSaveDCBonus maybePrimaryId Nothing Nothing maybeTargetToAreaShape maybePersonalToAreaShape

        title =
            if String.isEmpty spellName then
                "Unnamed Spell"

            else
                spellName

        augments =
            globalFactorLines Augmenting globalFactors

        mitigations =
            globalFactorLines Mitigating globalFactors

        seedBlocks =
            seedFactorBlocks instances

        seeds =
            uniqueSeeds instances

        primarySeed =
            primarySeedId instances maybePrimaryId

        ptRows rows =
            rows |> List.map (\( label, val ) -> label ++ ": " ++ val ++ "\n") |> String.concat

        bulletList items =
            if List.isEmpty items then
                "None\n"

            else
                items |> List.map (\i -> "- " ++ i ++ "\n") |> String.concat

        header label =
            let
                bar =
                    String.repeat 40 "-"
            in
            bar ++ "\n" ++ String.toUpper label ++ "\n" ++ bar ++ "\n\n"
    in
    title
        ++ "\n\n"
        ++ header "Stat Block"
        ++ ptRows (statBlockRows breakdown.finalDC sb)
        ++ "\n"
        ++ header "Seeds Used"
        ++ seedListLine maybePrimaryId instances
        ++ "\n\n"
        ++ header "DC Breakdown"
        ++ "Seeds: "
        ++ showSign breakdown.seedsTotal
        ++ "\n"
        ++ "Seed Factors: "
        ++ showSign breakdown.seedFactorsTotal
        ++ "\n"
        ++ "Augmenting: "
        ++ showSign breakdown.augmentingTotal
        ++ "\n"
        ++ (if breakdown.permanentMultiplier > 1 then
                "Permanent Duration: x5\n"

            else
                ""
           )
        ++ (if breakdown.stoneTabletMultiplier > 1 then
                "Stone Tablet: x2\n"

            else
                ""
           )
        ++ "Mitigating: "
        ++ showSign breakdown.mitigatingTotal
        ++ "\n"
        ++ "Final DC: "
        ++ String.fromInt breakdown.finalDC
        ++ "\n\n"
        ++ header "Development Costs"
        ++ "Gold Cost: "
        ++ formatNum costs.goldCost
        ++ " gp\n"
        ++ "Development Time: "
        ++ String.fromInt costs.timeDays
        ++ " days\n"
        ++ "XP Cost: "
        ++ formatNum costs.xpCost
        ++ " XP\n\n"
        ++ header "Seed Factors"
        ++ (if List.isEmpty seedBlocks then
                "None\n\n"

            else
                seedBlocks
                    |> List.map (\b -> b.label ++ ":\n" ++ bulletList b.lines ++ "\n")
                    |> String.concat
           )
        ++ header "Global Augments"
        ++ bulletList augments
        ++ "\n"
        ++ header "Global Mitigations"
        ++ bulletList mitigations
        ++ "\n"
        ++ header "Original Seed Listing"
        ++ (seeds
                |> List.map
                    (\seed ->
                        seed.name
                            ++ (if List.length seeds > 1 && primarySeed == Just seed.id then
                                    " (Primary)"

                                else
                                    ""
                               )
                            ++ "\n\n"
                            ++ ptRows (seedStatBlockRows seed)
                            ++ "\n"
                            ++ seed.description
                            ++ "\n\n"
                    )
                |> String.concat
           )
