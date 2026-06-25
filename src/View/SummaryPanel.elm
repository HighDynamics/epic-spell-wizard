module View.SummaryPanel exposing (viewSummaryPanel)

import Calc exposing (StatBlockData, availableSavingThrows, availableSchools)
import Dict
import Factors exposing (allFactors)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onBlur, onClick, onInput)
import Json.Decode as Decode
import Seeds exposing (getSeed, isSpecialSeedFactor)
import Types exposing (..)
import View.Icons exposing (shareIcon, summaryIcon)


mobileVis : Model -> String
mobileVis model =
    if model.activeMobileTab == SummaryTab then
        "flex"

    else
        "hidden"


viewSummaryPanel : Model -> DcBreakdown -> DevCosts -> StatBlockData -> Html Msg
viewSummaryPanel model breakdown costs sb =
    if model.summaryPanelOpen then
        div [ class (mobileVis model ++ " flex-col w-full md:flex md:w-96 shrink-0 bg-gray-900 overflow-hidden") ]
            [ -- Panel header
              div [ class "flex items-center justify-between px-4 py-3 border-b border-gray-700 shrink-0" ]
                [ span [ class "flex items-center gap-1.5 text-xs font-bold uppercase tracking-widest text-gray-400" ]
                    [ summaryIcon "w-3.5 h-3.5", text "Summary" ]
                , button
                    [ class "hidden md:inline-block text-gray-500 hover:text-gray-300 text-lg"
                    , onClick ToggleSummaryPanel
                    , title "Collapse panel"
                    ]
                    [ text "▶" ]
                ]
            , div [ class "flex-1 overflow-y-auto p-4 space-y-5" ]
                [ viewSpellNameSection model
                , viewStatBlock model breakdown sb
                , viewSeedsUsed model
                , viewDcBreakdown breakdown
                , viewDevCosts costs
                , viewSeedFactorsBySeed model
                , viewGlobalFactorList model "Global Augments" Augmenting
                , viewGlobalFactorList model "Global Mitigations" Mitigating
                ]
            , viewCopyFooter model
            ]

    else
        div
            [ class (mobileVis model ++ " flex-col items-center gap-2 w-full md:flex md:w-8 shrink-0 bg-gray-900 cursor-pointer hover:bg-gray-800 pt-4")
            , onClick ToggleSummaryPanel
            , title "Expand summary panel"
            ]
            [ summaryIcon "w-4 h-4 text-gray-500"
            , div
                [ style "writing-mode" "vertical-rl"
                , class "text-gray-500 text-xs whitespace-nowrap select-none"
                ]
                [ text "SUMMARY" ]
            ]


viewSpellNameSection : Model -> Html Msg
viewSpellNameSection model =
    div []
        [ div [ class "flex items-start justify-between gap-2" ]
            [ if model.renamingSpell then
                input
                    [ class "flex-1 min-w-0 bg-gray-800 border border-gray-600 rounded px-2 py-1 text-sm font-semibold text-gray-100 outline-none focus:border-arcane-400"
                    , value model.spellName
                    , onInput SetSpellName
                    , onBlur ToggleRenameSpell
                    , onEnter ToggleRenameSpell
                    , autofocus True
                    ]
                    []

              else
                span [ class "flex-1 min-w-0 text-sm font-semibold text-gray-200 break-words" ]
                    [ text (if String.isEmpty model.spellName then "Unnamed Spell" else model.spellName) ]
            , button
                [ class "shrink-0 text-arcane-400 opacity-60 hover:opacity-100"
                , onClick CopyShareLink
                , title "Copy shareable link"
                ]
                [ shareIcon "w-4 h-4" ]
            ]
        , button
            [ class "mt-1 text-xs text-gray-500 hover:text-gray-300 underline"
            , onClick ToggleRenameSpell
            ]
            [ text
                (if model.renamingSpell then
                    "Finish renaming"

                 else
                    "Rename this spell"
                )
            ]
        , case ( model.pendingCopy, model.copySuccess ) of
            ( Just ShareCopyTarget, Just True ) ->
                div [ class "text-green-400 text-xs mt-1" ] [ text "Link copied!" ]

            ( Just ShareCopyTarget, Just False ) ->
                div [ class "text-red-400 text-xs mt-1" ] [ text "Copy failed — check browser permissions." ]

            _ ->
                text ""
        ]


resolvePrimaryInstanceId : Model -> Maybe SeedInstanceId
resolvePrimaryInstanceId model =
    case model.primarySeedInstanceId of
        Just pid ->
            if List.any (\i -> i.instanceId == pid) model.seedInstances then
                Just pid

            else
                List.head model.seedInstances |> Maybe.map .instanceId

        Nothing ->
            List.head model.seedInstances |> Maybe.map .instanceId


viewSeedsUsed : Model -> Html Msg
viewSeedsUsed model =
    let
        primaryId =
            resolvePrimaryInstanceId model

        showPrimaryTag =
            List.length model.seedInstances > 1

        names =
            model.seedInstances
                |> List.filterMap
                    (\inst ->
                        getSeed inst.seedId
                            |> Maybe.map
                                (\s ->
                                    s.name
                                        ++ " ("
                                        ++ String.fromInt (Maybe.withDefault s.baseDC inst.baseDCOverride)
                                        ++ ")"
                                        ++ (if showPrimaryTag && primaryId == Just inst.instanceId then
                                                " [Primary]"

                                            else
                                                ""
                                           )
                                )
                    )
    in
    div []
        [ div [ class "text-xs font-bold uppercase tracking-widest text-gray-400 mb-2" ] [ text "Seeds Used" ]
        , div [ class "text-xs text-gray-200" ]
            [ text (if List.isEmpty names then "None" else String.join ", " names) ]
        ]


viewDcBreakdown : DcBreakdown -> Html Msg
viewDcBreakdown bd =
    div []
        [ div [ class "text-xs font-bold uppercase tracking-widest text-gray-400 mb-2" ] [ text "DC Breakdown" ]
        , div [ class "space-y-1 text-sm" ]
            [ viewBreakdownRow "Seeds" (showSign bd.seedsTotal) "text-gray-300"
            , viewBreakdownRow "Seed factors" (showSign bd.seedFactorsTotal) "text-gray-300"
            , viewBreakdownRow "Augmenting" (showSign bd.augmentingTotal) "text-gray-300"
            , if bd.permanentMultiplier > 1 then
                viewBreakdownRow "× Permanent" ("×" ++ String.fromInt bd.permanentMultiplier) "text-yellow-400"

              else
                text ""
            , if bd.stoneTabletMultiplier > 1 then
                viewBreakdownRow "× Stone Tablet" ("×" ++ String.fromInt bd.stoneTabletMultiplier) "text-yellow-400"

              else
                text ""
            , viewBreakdownRow "Mitigating" (showSign bd.mitigatingTotal) "text-green-400"
            , div [ class "border-t border-gray-700 pt-1 mt-1 flex justify-between" ]
                [ span [ class "text-gray-400 text-xs uppercase" ] [ text "Final DC" ]
                , span [ class "text-arcane-400 text-lg font-bold tabular-nums" ]
                    [ text (String.fromInt bd.finalDC) ]
                ]
            ]
        ]


viewBreakdownRow : String -> String -> String -> Html Msg
viewBreakdownRow label val colorClass =
    div [ class "flex justify-between" ]
        [ span [ class "text-gray-500 text-xs" ] [ text label ]
        , span [ class ("text-xs tabular-nums " ++ colorClass) ] [ text val ]
        ]


showSign : Int -> String
showSign n =
    if n >= 0 then
        "+" ++ String.fromInt n

    else
        String.fromInt n


viewDevCosts : DevCosts -> Html Msg
viewDevCosts costs =
    div []
        [ div [ class "text-xs font-bold uppercase tracking-widest text-gray-400 mb-2" ] [ text "Development" ]
        , div [ class "space-y-1" ]
            [ viewCostRow "Gold" (formatNumber costs.goldCost ++ " gp")
            , viewCostRow "Time" (String.fromInt costs.timeDays ++ " days")
            , viewCostRow "XP" (formatNumber costs.xpCost ++ " XP")
            ]
        ]


viewCostRow : String -> String -> Html Msg
viewCostRow label val =
    div [ class "flex justify-between text-sm" ]
        [ span [ class "text-gray-500 text-xs" ] [ text label ]
        , span [ class "text-gray-200 text-xs tabular-nums" ] [ text val ]
        ]


formatNumber : Int -> String
formatNumber n =
    -- Insert commas: 423000 → "423,000"
    let
        str =
            String.fromInt n

        len =
            String.length str
    in
    if len <= 3 then
        str

    else
        formatNumber (n // 1000) ++ "," ++ String.padLeft 3 '0' (String.fromInt (modBy 1000 n))


saveTypeLabel : SavingThrowType -> String
saveTypeLabel st =
    case st of
        WillSave ->
            "Will"

        ReflexSave ->
            "Reflex"

        FortSave ->
            "Fortitude"


viewStatBlock : Model -> DcBreakdown -> StatBlockData -> Html Msg
viewStatBlock model breakdown sb =
    let
        row label val =
            div [ class "flex gap-2 text-xs" ]
                [ span [ class "text-gray-500 w-24 shrink-0" ] [ text label ]
                , span [ class "text-gray-200" ] [ text val ]
                ]

        rowEl label el =
            div [ class "flex gap-2 text-xs items-start" ]
                [ span [ class "text-gray-500 w-24 shrink-0" ] [ text label ]
                , el
                ]

        descriptorStr =
            if List.isEmpty sb.descriptors then
                ""

            else
                " [" ++ String.join ", " sb.descriptors ++ "]"

        schools =
            availableSchools model.seedInstances

        schoolEl =
            case schools of
                [] ->
                    span [ class "text-gray-200" ] [ text "—" ]

                [ single ] ->
                    div []
                        [ span [ class "text-gray-200" ] [ text single ]
                        , if List.isEmpty sb.descriptors then
                            text ""

                          else
                            div [ class "text-gray-400 mt-1" ] [ text descriptorStr ]
                        ]

                _ ->
                    let
                        activeSchool =
                            Maybe.withDefault
                                (Maybe.withDefault "" (List.head schools))
                                model.selectedSchool
                    in
                    div []
                        [ div [ class "flex flex-wrap gap-1" ]
                            (List.map
                                (\s ->
                                    button
                                        [ class
                                            (if s == activeSchool then
                                                "text-xs px-2 py-0.5 rounded bg-indigo-600 text-white"

                                             else
                                                "text-xs px-2 py-0.5 rounded bg-gray-700 text-gray-500 hover:text-gray-300 hover:bg-gray-600"
                                            )
                                        , onClick (SetSchool s)
                                        ]
                                        [ text s ]
                                )
                                schools
                            )
                        , if List.isEmpty sb.descriptors then
                            text ""

                          else
                            div [ class "text-gray-400 mt-1" ] [ text descriptorStr ]
                        ]

        availableSaves =
            availableSavingThrows model.seedInstances

        savingThrowEl =
            case availableSaves of
                [] ->
                    span [ class "text-gray-200" ] [ text "None" ]

                [ _ ] ->
                    span [ class "text-gray-200" ] [ text sb.savingThrow ]

                _ ->
                    let
                        currentTypeStr =
                            model.selectedSavingThrow
                                |> Maybe.map (.saveType >> saveTypeLabel)
                                |> Maybe.withDefault
                                    (List.head availableSaves
                                        |> Maybe.map (.saveType >> saveTypeLabel)
                                        |> Maybe.withDefault ""
                                    )

                        effects =
                            List.map .effect availableSaves

                        effectStr =
                            case List.head effects of
                                Nothing ->
                                    ""

                                Just first ->
                                    if List.all (\e -> e == first) effects then
                                        case first of
                                            Negates -> "negates"
                                            Half -> "half"
                                            Partial -> "partial"
                                            SeeText -> "(see text)"

                                    else
                                        "(see text)"

                        harmlessStr =
                            if List.all .harmless availableSaves then
                                " (harmless)"

                            else
                                ""
                    in
                    div [ class "flex flex-wrap items-center gap-1" ]
                        [ select
                            [ class "bg-gray-800 text-gray-200 text-xs rounded px-1 py-0.5"
                            , onInput
                                (\typeStr ->
                                    SetSavingThrow
                                        (List.filter (\st -> saveTypeLabel st.saveType == typeStr) availableSaves
                                            |> List.head
                                        )
                                )
                            , value currentTypeStr
                            ]
                            (List.map
                                (\st ->
                                    let
                                        label =
                                            saveTypeLabel st.saveType
                                    in
                                    option
                                        [ value label
                                        , selected (currentTypeStr == label)
                                        ]
                                        [ text label ]
                                )
                                availableSaves
                            )
                        , span [ class "text-gray-200" ] [ text (effectStr ++ harmlessStr) ]
                        ]
    in
    div []
        [ div [ class "text-xs font-bold uppercase tracking-widest text-gray-400 mb-2" ] [ text "Stat Block" ]
        , div [ class "space-y-1" ]
            ([ rowEl (if List.length schools > 1 then "School (pick)" else "School") schoolEl
             , row "Spellcraft DC" (String.fromInt breakdown.finalDC)
             , row "Components" (String.join ", " sb.components)
             , row "Casting Time" sb.castingTime
             , row "Range" sb.range
             ]
                ++ List.filterMap identity
                    [ Maybe.map (row "Target") sb.target
                    , Maybe.map (row "Area") sb.area
                    , Maybe.map (row "Effect") sb.effect
                    ]
                ++ [ row "Duration" sb.duration
                   , rowEl "Saving Throw" savingThrowEl
                   , row "Spell Resistance" sb.spellResistance
                   ]
            )
        ]


viewGlobalFactorList : Model -> String -> FactorCategory -> Html Msg
viewGlobalFactorList model label category =
    let
        lines =
            model.appliedFactors
                |> List.filterMap
                    (\af ->
                        allFactors
                            |> List.filter (\f -> f.id == af.factorId && f.category == category)
                            |> List.head
                            |> Maybe.map
                                (\f ->
                                    f.name
                                        ++ (if af.quantity > 1 then " ×" ++ String.fromInt af.quantity else "")
                                        ++ (if f.kind == DcMultiplier then
                                                " (×" ++ String.fromInt f.multiplierValue ++ ")"

                                            else
                                                " (" ++ showSign (f.dcModifier * af.quantity) ++ ")"
                                           )
                                )
                    )
    in
    div []
        [ div [ class "text-xs font-bold uppercase tracking-widest text-gray-400 mb-2" ] [ text label ]
        , if List.isEmpty lines then
            p [ class "text-gray-500 text-xs italic" ] [ text "None active" ]

          else
            div [ class "space-y-1" ]
                (List.map (\l -> div [ class "text-gray-200 text-xs" ] [ text l ]) lines)
        ]


viewSeedFactorsBySeed : Model -> Html Msg
viewSeedFactorsBySeed model =
    let
        blocks =
            model.seedInstances
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
                                                    let
                                                        selected =
                                                            Dict.get c.id inst.choices |> Maybe.withDefault c.default

                                                        dcSuffix =
                                                            c.dcModifiers
                                                                |> List.filter (\( opt, _ ) -> opt == selected)
                                                                |> List.head
                                                                |> Maybe.map (\( _, dc ) -> " (" ++ showSign dc ++ " DC)")
                                                                |> Maybe.withDefault ""
                                                    in
                                                    c.label ++ ": " ++ selected ++ dcSuffix
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
                                                                    ++ (if asf.quantity > 1 then " ×" ++ String.fromInt asf.quantity else "")
                                                                    ++ (if isSpecialSeedFactor sf.id then
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
                                    , acc ++ [ ( label, lines ) ]
                                    )
                    )
                    ( Dict.empty, [] )
                |> Tuple.second
                |> List.sortBy Tuple.first
    in
    div []
        [ div [ class "text-xs font-bold uppercase tracking-widest text-gray-400 mb-2" ] [ text "Seed Factors" ]
        , if List.isEmpty blocks then
            p [ class "text-gray-500 text-xs italic" ] [ text "No seed-specific factors active" ]

          else
            div [ class "space-y-2" ]
                (List.map
                    (\( label, lines ) ->
                        div []
                            [ div [ class "text-arcane-400 text-xs font-semibold mb-1" ] [ text label ]
                            , div [ class "space-y-0.5" ]
                                (List.map (\l -> div [ class "text-gray-200 text-xs" ] [ text l ]) lines)
                            ]
                    )
                    blocks
                )
        ]


viewCopyFooter : Model -> Html Msg
viewCopyFooter model =
    div [ class "shrink-0 border-t border-gray-700 bg-gray-900 p-4 space-y-2" ]
        [ div [ class "flex rounded overflow-hidden border border-gray-700" ]
            [ formatButton model PlainTextExport "Plain Text"
            , formatButton model MarkdownExport "Markdown"
            ]
        , button
            [ class "w-full py-2 rounded bg-arcane-500 hover:bg-arcane-400 text-white text-sm font-semibold"
            , onClick CopySpellSummary
            ]
            [ text "Copy Spell Summary" ]
        , case ( model.pendingCopy, model.copySuccess ) of
            ( Just SummaryCopyTarget, Just True ) ->
                div [ class "text-green-400 text-xs text-center" ] [ text "Copied to clipboard!" ]

            ( Just SummaryCopyTarget, Just False ) ->
                div [ class "text-red-400 text-xs text-center" ] [ text "Copy failed — check browser permissions." ]

            _ ->
                text ""
        ]


onEnter : Msg -> Html.Attribute Msg
onEnter msg =
    on "keydown"
        (Decode.field "key" Decode.string
            |> Decode.andThen
                (\key ->
                    if key == "Enter" then
                        Decode.succeed msg

                    else
                        Decode.fail "not Enter"
                )
        )


formatButton : Model -> ExportFormat -> String -> Html Msg
formatButton model fmt label =
    button
        [ class
            ("flex-1 py-1.5 text-xs font-semibold "
                ++ (if model.exportFormat == fmt then
                        "bg-gray-600 text-gray-100"

                    else
                        "bg-gray-800 text-gray-400 hover:bg-gray-700"
                   )
            )
        , onClick (SetExportFormat fmt)
        ]
        [ text label ]
