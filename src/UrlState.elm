module UrlState exposing (applyQuery, encode, extractQuery)

import Dict exposing (Dict)
import Factors exposing (allFactors, getFactor)
import Seeds exposing (allSeeds, getSeed)
import Types exposing (..)
import Url
import Url.Builder as UB


-- ─── Encode ───────────────────────────────────────────────────────────────────


encode : Model -> String
encode model =
    UB.toQuery (List.filterMap identity (params model))
        |> escapeForSharing


-- Url.Builder's percent-encoding (JS encodeURIComponent under the hood)
-- deliberately leaves ( ) ! * ' ~ unescaped, since they're legal in a URI.
-- But several factor/seed names contain literal parens (e.g. "Backlash
-- (1d6 per die to caster)"), and the spell name is free text that could
-- contain any of these — and plenty of real-world link handlers (chat
-- apps, markdown auto-linkers) mis-truncate URLs with literal parens in
-- them. Escape them too; decoding is unaffected either way.
escapeForSharing : String -> String
escapeForSharing s =
    s
        |> String.replace "(" "%28"
        |> String.replace ")" "%29"
        |> String.replace "!" "%21"
        |> String.replace "*" "%2A"
        |> String.replace "'" "%27"
        |> String.replace "~" "%7E"


params : Model -> List (Maybe UB.QueryParameter)
params model =
    [ if String.isEmpty model.spellName then
        Nothing

      else
        Just (UB.string "name" model.spellName)
    , Maybe.map (UB.string "school") model.selectedSchool
    , Maybe.map (UB.string "save" << encodeSavingThrow) model.selectedSavingThrow
    , Maybe.map (UB.string "t2a" << encodeShapeSlug) model.targetToAreaShape
    , Maybe.map (UB.string "p2a" << encodeShapeSlug) model.personalToAreaShape
    , Maybe.map (UB.string "bolt" << encodeShapeSlug) model.boltShape
    , let
        panelsStr =
            boolFlag model.seedsPanelOpen ++ boolFlag model.factorsPanelOpen ++ boolFlag model.summaryPanelOpen
      in
      if panelsStr == "111" then
        Nothing

      else
        Just (UB.string "panels" panelsStr)
    , model.primarySeedInstanceId
        |> Maybe.andThen (\pid -> indexOfInstance pid model.seedInstances)
        |> Maybe.map (\idx -> UB.string "primary" (String.fromInt idx))
    , if List.isEmpty model.seedInstances then
        Nothing

      else
        Just (UB.string "seeds" (encodeSeedInstances model.seedInstances))
    , if List.isEmpty model.appliedFactors then
        Nothing

      else
        Just (UB.string "factors" (encodeAppliedFactors model.appliedFactors))
    ]


-- The Target/Personal -> Area and bolt shape pickers store the full display
-- label (e.g. "Bolt (5 ft. × 300 ft.)") as the selected value. Parentheses
-- and "×" are legal but unescaped by percent-encoding, which some link
-- handlers (chat apps, markdown auto-linkers) mishandle. Use plain ASCII
-- slugs in the URL instead, translating back to the display label on load.
encodeShapeSlug : String -> String
encodeShapeSlug shape =
    case shape of
        "Bolt (5 ft. × 300 ft.)" ->
            "bolt-5x300"

        "Bolt (10 ft. × 150 ft.)" ->
            "bolt-10x150"

        "Cylinder" ->
            "cylinder"

        "40-ft. cone" ->
            "cone"

        "Four 10-ft. cubes" ->
            "cubes"

        "20-ft. radius" ->
            "radius"

        other ->
            other


decodeShapeSlug : String -> String
decodeShapeSlug slug =
    case slug of
        "bolt-5x300" ->
            "Bolt (5 ft. × 300 ft.)"

        "bolt-10x150" ->
            "Bolt (10 ft. × 150 ft.)"

        "cylinder" ->
            "Cylinder"

        "cone" ->
            "40-ft. cone"

        "cubes" ->
            "Four 10-ft. cubes"

        "radius" ->
            "20-ft. radius"

        other ->
            other


boolFlag : Bool -> String
boolFlag b =
    if b then
        "1"

    else
        "0"


indexOfInstance : SeedInstanceId -> List SeedInstance -> Maybe Int
indexOfInstance pid instances =
    instances
        |> List.indexedMap Tuple.pair
        |> List.filter (\( _, inst ) -> inst.instanceId == pid)
        |> List.head
        |> Maybe.map Tuple.first


encodeSavingThrow : SavingThrow -> String
encodeSavingThrow st =
    saveTypeToString st.saveType ++ "|" ++ saveEffectToString st.effect ++ "|" ++ boolFlag st.harmless


saveTypeToString : SavingThrowType -> String
saveTypeToString st =
    case st of
        WillSave ->
            "Will"

        ReflexSave ->
            "Reflex"

        FortSave ->
            "Fort"


saveTypeFromString : String -> Maybe SavingThrowType
saveTypeFromString s =
    case s of
        "Will" ->
            Just WillSave

        "Reflex" ->
            Just ReflexSave

        "Fort" ->
            Just FortSave

        _ ->
            Nothing


saveEffectToString : SaveEffect -> String
saveEffectToString e =
    case e of
        Negates ->
            "Negates"

        Half ->
            "Half"

        Partial ->
            "Partial"

        SeeText ->
            "SeeText"


saveEffectFromString : String -> Maybe SaveEffect
saveEffectFromString s =
    case s of
        "Negates" ->
            Just Negates

        "Half" ->
            Just Half

        "Partial" ->
            Just Partial

        "SeeText" ->
            Just SeeText

        _ ->
            Nothing


-- Stable, all-alphanumeric codes for FactorId/SeedId, used in place of the
-- human-readable .name strings in the URL. Plain escaping isn't durable —
-- some link handlers (chat apps, markdown auto-linkers) decode percent
-- escapes back into the original characters before re-processing a pasted
-- link, reintroducing the same literal-parens problem.
--
-- Each entry's code is fixed at the table row itself, not derived from its
-- position — so reordering, regrouping, or inserting rows is always safe.
-- The only rule: never change or reuse a code that's already assigned to a
-- constructor; always give a new constructor a fresh, never-before-used
-- code, and append its row anywhere in the table.
--
-- Decode falls back to matching against .name for links generated before
-- this scheme existed.
factorIdCodeTable : List ( String, FactorId )
factorIdCodeTable =
    [ ( "0", ReduceCastTime1Round )
    , ( "1", OneActionCastTime )
    , ( "2", QuickenedSpell )
    , ( "3", Contingent )
    , ( "4", NoVerbal )
    , ( "5", NoSomatic )
    , ( "6", IncreaseDuration )
    , ( "7", PermanentDuration )
    , ( "8", Dismissible )
    , ( "9", IncreaseRange )
    , ( "a", AddExtraTarget )
    , ( "b", TargetToArea )
    , ( "c", PersonalToArea )
    , ( "d", TargetToTouch )
    , ( "e", TouchToTarget )
    , ( "f", ChangeToBolt )
    , ( "g", ChangeToCylinder )
    , ( "h", ChangeToCone )
    , ( "i", ChangeToFourCubes )
    , ( "j", ChangeToRadius )
    , ( "k", AreaToTarget )
    , ( "l", AreaToTouch )
    , ( "m", IncreaseArea )
    , ( "n", IncreaseSaveDC )
    , ( "o", IncreaseSRCheck )
    , ( "p", IncreaseVsDispel )
    , ( "q", StoneTablet )
    , ( "r", IncreaseDamageDie )
    , ( "s", Backlash )
    , ( "t", XPBurn )
    , ( "u", IncreaseCastTime1Min )
    , ( "v", IncreaseCastTime1Day )
    , ( "w", ChangeToPersonal )
    , ( "x", DecreaseDamageDie )
    , ( "y", RitualSlot1 )
    , ( "z", RitualSlot2 )
    , ( "10", RitualSlot3 )
    , ( "11", RitualSlot4 )
    , ( "12", RitualSlot5 )
    , ( "13", RitualSlot6 )
    , ( "14", RitualSlot7 )
    , ( "15", RitualSlot8 )
    , ( "16", RitualSlot9 )
    , ( "17", RitualSlotEpic )
    ]


seedIdCodeTable : List ( String, SeedId )
seedIdCodeTable =
    [ ( "0", Afflict )
    , ( "1", Animate )
    , ( "2", AnimateDead )
    , ( "3", Armor )
    , ( "4", Banish )
    , ( "5", Compel )
    , ( "6", Conceal )
    , ( "7", Conjure )
    , ( "8", Contact )
    , ( "9", Delude )
    , ( "a", Destroy )
    , ( "b", Dispel )
    , ( "c", Energy )
    , ( "d", Foresee )
    , ( "e", Fortify )
    , ( "f", Heal )
    , ( "g", Life )
    , ( "h", Reflect )
    , ( "i", Reveal )
    , ( "j", Slay )
    , ( "k", Summon )
    , ( "l", Transform )
    , ( "m", Transport )
    , ( "n", Ward )
    ]


factorIdCode : FactorId -> String
factorIdCode factorId =
    factorIdCodeTable
        |> List.filter (\( _, f ) -> f == factorId)
        |> List.head
        |> Maybe.map Tuple.first
        |> Maybe.withDefault ""


factorIdFromCode : String -> Maybe FactorId
factorIdFromCode code =
    factorIdCodeTable
        |> List.filter (\( c, _ ) -> c == code)
        |> List.head
        |> Maybe.map Tuple.second


seedIdCode : SeedId -> String
seedIdCode seedId =
    seedIdCodeTable
        |> List.filter (\( _, s ) -> s == seedId)
        |> List.head
        |> Maybe.map Tuple.first
        |> Maybe.withDefault ""


seedIdFromCode : String -> Maybe SeedId
seedIdFromCode code =
    seedIdCodeTable
        |> List.filter (\( c, _ ) -> c == code)
        |> List.head
        |> Maybe.map Tuple.second


encodeSeedInstances : List SeedInstance -> String
encodeSeedInstances instances =
    instances
        |> List.map encodeSeedInstance
        |> String.join ";"


encodeSeedInstance : SeedInstance -> String
encodeSeedInstance inst =
    seedIdCode inst.seedId
        ++ ":"
        ++ (inst.baseDCOverride |> Maybe.map String.fromInt |> Maybe.withDefault "")
        ++ ":"
        ++ (Dict.toList inst.choices |> List.map (\( k, v ) -> k ++ "=" ++ v) |> String.join ",")
        ++ ":"
        ++ (inst.appliedSeedFactors |> List.map (\af -> af.factorId ++ "=" ++ String.fromInt af.quantity) |> String.join ",")


encodeAppliedFactors : List AppliedFactor -> String
encodeAppliedFactors factors =
    factors
        |> List.map
            (\af -> factorIdCode af.factorId ++ "=" ++ String.fromInt af.quantity)
        |> String.join ","



-- ─── Decode ───────────────────────────────────────────────────────────────────


applyQuery : String -> Model -> Model
applyQuery search model =
    let
        query =
            parseParams search

        decodedInstances =
            Dict.get "seeds" query
                |> Maybe.map decodeSeedInstances
                |> Maybe.withDefault model.seedInstances

        primaryFromIndex =
            Dict.get "primary" query
                |> Maybe.andThen String.toInt
                |> Maybe.andThen (\idx -> List.head (List.drop idx decodedInstances))
                |> Maybe.map .instanceId
    in
    { model
        | spellName = Dict.get "name" query |> Maybe.withDefault model.spellName
        , selectedSchool = Dict.get "school" query |> Maybe.map Just |> Maybe.withDefault model.selectedSchool
        , selectedSavingThrow =
            Dict.get "save" query
                |> Maybe.map decodeSavingThrow
                |> Maybe.withDefault model.selectedSavingThrow
        , targetToAreaShape = Dict.get "t2a" query |> Maybe.map (Just << decodeShapeSlug) |> Maybe.withDefault model.targetToAreaShape
        , personalToAreaShape = Dict.get "p2a" query |> Maybe.map (Just << decodeShapeSlug) |> Maybe.withDefault model.personalToAreaShape
        , boltShape = Dict.get "bolt" query |> Maybe.map (Just << decodeShapeSlug) |> Maybe.withDefault model.boltShape
        , seedsPanelOpen = Dict.get "panels" query |> Maybe.andThen panelFlagAt0 |> Maybe.withDefault model.seedsPanelOpen
        , factorsPanelOpen = Dict.get "panels" query |> Maybe.andThen panelFlagAt1 |> Maybe.withDefault model.factorsPanelOpen
        , summaryPanelOpen = Dict.get "panels" query |> Maybe.andThen panelFlagAt2 |> Maybe.withDefault model.summaryPanelOpen
        , seedInstances = decodedInstances
        , nextInstanceId = List.length decodedInstances
        , primarySeedInstanceId = primaryFromIndex
        , appliedFactors =
            Dict.get "factors" query
                |> Maybe.map decodeAppliedFactors
                |> Maybe.withDefault model.appliedFactors
    }


-- Accepts a pasted full URL ("https://host/path?name=...") or a bare
-- query string ("?name=..." or "name=...") and returns the query portion
-- suitable for `applyQuery`.
extractQuery : String -> String
extractQuery input =
    let
        trimmed =
            String.trim input
    in
    case String.indexes "?" trimmed of
        idx :: _ ->
            String.dropLeft idx trimmed

        [] ->
            trimmed


parseParams : String -> Dict String String
parseParams search =
    search
        |> dropLeadingQuestionMark
        |> String.split "&"
        |> List.filterMap parsePair
        |> Dict.fromList


dropLeadingQuestionMark : String -> String
dropLeadingQuestionMark s =
    if String.startsWith "?" s then
        String.dropLeft 1 s

    else
        s


parsePair : String -> Maybe ( String, String )
parsePair pair =
    case String.split "=" pair of
        [ k, v ] ->
            Maybe.map2 Tuple.pair (Url.percentDecode k) (Url.percentDecode v)

        _ ->
            Nothing


panelFlagAt : Int -> String -> Maybe Bool
panelFlagAt i s =
    String.toList s
        |> List.drop i
        |> List.head
        |> Maybe.map (\c -> c == '1')


panelFlagAt0 : String -> Maybe Bool
panelFlagAt0 =
    panelFlagAt 0


panelFlagAt1 : String -> Maybe Bool
panelFlagAt1 =
    panelFlagAt 1


panelFlagAt2 : String -> Maybe Bool
panelFlagAt2 =
    panelFlagAt 2


decodeSavingThrow : String -> Maybe SavingThrow
decodeSavingThrow s =
    case String.split "|" s of
        [ typeStr, effectStr, harmlessStr ] ->
            Maybe.map3
                (\t e h -> { saveType = t, effect = e, harmless = h })
                (saveTypeFromString typeStr)
                (saveEffectFromString effectStr)
                (Just (harmlessStr == "1"))

        _ ->
            Nothing


decodeSeedInstances : String -> List SeedInstance
decodeSeedInstances raw =
    raw
        |> String.split ";"
        |> List.filterMap decodeSeedInstance
        |> List.indexedMap (\idx inst -> { inst | instanceId = idx })


decodeSeedInstance : String -> Maybe SeedInstance
decodeSeedInstance raw =
    case String.split ":" raw of
        [ seedNameStr, baseDCStr, choicesStr, factorsStr ] ->
            -- New-style links carry the SeedId's stable code; old-style
            -- links carry the seed's display name (e.g. "Animate Dead").
            case seedIdFromCode seedNameStr |> Maybe.andThen getSeed of
                Just seed ->
                    Just
                        { instanceId = 0
                        , seedId = seed.id
                        , appliedSeedFactors = decodeAppliedSeedFactors factorsStr
                        , choices = decodeChoices choicesStr
                        , baseDCOverride = String.toInt baseDCStr
                        }

                Nothing ->
                    allSeeds
                        |> List.filter (\s -> s.name == seedNameStr)
                        |> List.head
                        |> Maybe.map
                            (\seed ->
                                { instanceId = 0
                                , seedId = seed.id
                                , appliedSeedFactors = decodeAppliedSeedFactors factorsStr
                                , choices = decodeChoices choicesStr
                                , baseDCOverride = String.toInt baseDCStr
                                }
                            )

        _ ->
            Nothing


decodeChoices : String -> Dict String String
decodeChoices s =
    if String.isEmpty s then
        Dict.empty

    else
        s
            |> String.split ","
            |> List.filterMap (splitOnEquals)
            |> Dict.fromList


decodeAppliedSeedFactors : String -> List AppliedSeedFactor
decodeAppliedSeedFactors s =
    if String.isEmpty s then
        []

    else
        s
            |> String.split ","
            |> List.filterMap
                (\pair ->
                    splitOnEquals pair
                        |> Maybe.andThen
                            (\( factorId, qtyStr ) ->
                                String.toInt qtyStr |> Maybe.map (\qty -> { factorId = factorId, quantity = qty })
                            )
                )


decodeAppliedFactors : String -> List AppliedFactor
decodeAppliedFactors s =
    if String.isEmpty s then
        []

    else
        s
            |> String.split ","
            |> List.filterMap
                (\pair ->
                    splitOnEquals pair
                        |> Maybe.andThen
                            (\( codeOrName, qtyStr ) ->
                                let
                                    -- New-style links carry the FactorId's stable
                                    -- code; old-style links carry the factor's
                                    -- display name (e.g. "Backlash (1d6 per die
                                    -- to caster)").
                                    maybeFactor =
                                        case factorIdFromCode codeOrName |> Maybe.andThen getFactor of
                                            Just f ->
                                                Just f

                                            Nothing ->
                                                allFactors |> List.filter (\f -> f.name == codeOrName) |> List.head
                                in
                                Maybe.map2 (\f qty -> { factorId = f.id, quantity = qty })
                                    maybeFactor
                                    (String.toInt qtyStr)
                            )
                )


splitOnEquals : String -> Maybe ( String, String )
splitOnEquals pair =
    case String.split "=" pair of
        [ k, v ] ->
            Just ( k, v )

        _ ->
            Nothing
