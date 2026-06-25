module UrlState exposing (applyQuery, encode)

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


params : Model -> List (Maybe UB.QueryParameter)
params model =
    [ if String.isEmpty model.spellName then
        Nothing

      else
        Just (UB.string "name" model.spellName)
    , Maybe.map (UB.string "school") model.selectedSchool
    , Maybe.map (UB.string "save" << encodeSavingThrow) model.selectedSavingThrow
    , Maybe.map (UB.string "t2a") model.targetToAreaShape
    , Maybe.map (UB.string "p2a") model.personalToAreaShape
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


encodeSeedInstances : List SeedInstance -> String
encodeSeedInstances instances =
    instances
        |> List.filterMap encodeSeedInstance
        |> String.join ";"


encodeSeedInstance : SeedInstance -> Maybe String
encodeSeedInstance inst =
    getSeed inst.seedId
        |> Maybe.map
            (\seed ->
                seed.name
                    ++ ":"
                    ++ (inst.baseDCOverride |> Maybe.map String.fromInt |> Maybe.withDefault "")
                    ++ ":"
                    ++ (Dict.toList inst.choices |> List.map (\( k, v ) -> k ++ "=" ++ v) |> String.join ",")
                    ++ ":"
                    ++ (inst.appliedSeedFactors |> List.map (\af -> af.factorId ++ "=" ++ String.fromInt af.quantity) |> String.join ",")
            )


encodeAppliedFactors : List AppliedFactor -> String
encodeAppliedFactors factors =
    factors
        |> List.filterMap
            (\af -> getFactor af.factorId |> Maybe.map (\f -> f.name ++ "=" ++ String.fromInt af.quantity))
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
        , targetToAreaShape = Dict.get "t2a" query |> Maybe.map Just |> Maybe.withDefault model.targetToAreaShape
        , personalToAreaShape = Dict.get "p2a" query |> Maybe.map Just |> Maybe.withDefault model.personalToAreaShape
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
                            (\( name, qtyStr ) ->
                                Maybe.map2 (\f qty -> { factorId = f.id, quantity = qty })
                                    (allFactors |> List.filter (\f -> f.name == name) |> List.head)
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
