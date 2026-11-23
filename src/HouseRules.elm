module HouseRules exposing
    ( Change
    , Effect(..)
    , Option(..)
    , affected
    , changes
    , dropUnoffered
    , isOffered
    , offered
    , optionName
    , reset
    )

{-| The Sojourner Saga campaign's house rules, as a list of changes to the
options the rules as written offer.

Each change adds an option, removes one, or replaces one with another. A
replacement is its own option (a separate seed, seed factor or global factor
with its own numbers) that is offered in place of the original while house
rules are on, so the DC calculation never needs to know which rules are in
force: it only ever sees options that were offered.

-}

import Factors exposing (getFactor)
import Seeds exposing (getSeed)
import SpellEdit
import Types exposing (..)


{-| Something the spell builder lets you select.
-}
type Option
    = SeedOption SeedId
    | SeedFactorOption SeedId String
    | GlobalFactorOption FactorId


type Effect
    = Adds Option
    | Removes Option
      -- The option the rules as written offer, then the one offered in its place.
    | Replaces Option Option


type alias Change =
    { description : String
    , effect : Effect
    }


changes : List Change
changes =
    []



-- ─── Availability ────────────────────────────────────────────────────────────


{-| Whether an option is offered with house rules on (True) or off (False).
-}
offered : List Change -> Bool -> Option -> Bool
offered changeList houseRulesOn option =
    let
        withdraws change =
            case ( change.effect, houseRulesOn ) of
                ( Adds added, False ) ->
                    added == option

                ( Removes removed, True ) ->
                    removed == option

                ( Replaces original _, True ) ->
                    original == option

                ( Replaces _ replacement, False ) ->
                    replacement == option

                _ ->
                    False
    in
    not (List.any withdraws changeList)


{-| `offered` for the campaign's own change list.
-}
isOffered : Bool -> Option -> Bool
isOffered =
    offered changes



-- ─── Switching ───────────────────────────────────────────────────────────────


{-| Everything switching house rules to the given setting would take out of
the spell. First, the options it uses that the new setting doesn't offer:
turning house rules on withdraws the options they remove or replace, turning
them off withdraws the ones they add or put in another's place. Then
whatever goes with those, like the global factors when the spell's last seed
is withdrawn. A withdrawn seed's own seed factors aren't listed, since they
go with the seed.
-}
affected : List Change -> Bool -> Model -> List Option
affected changeList houseRulesOn model =
    let
        inUse =
            optionsInUse model

        remaining =
            optionsInUse (reset (List.filter (not << offered changeList houseRulesOn) inUse) model)

        lost =
            List.filter (\option -> not (List.member option remaining)) inUse

        goesWithLostSeed option =
            case option of
                SeedFactorOption seedId _ ->
                    List.member (SeedOption seedId) lost

                _ ->
                    False
    in
    List.filter (not << goesWithLostSeed) lost


optionsInUse : Model -> List Option
optionsInUse model =
    let
        seedOptions =
            List.map (\inst -> SeedOption inst.seedId) model.seedInstances

        seedFactorOptions =
            List.concatMap
                (\inst ->
                    List.map (\asf -> SeedFactorOption inst.seedId asf.factorId) inst.appliedSeedFactors
                )
                model.seedInstances

        globalFactorOptions =
            List.map (\af -> GlobalFactorOption af.factorId) model.appliedFactors
    in
    unique (seedOptions ++ seedFactorOptions ++ globalFactorOptions)


unique : List a -> List a
unique =
    List.foldr
        (\x acc ->
            if List.member x acc then
                acc

            else
                x :: acc
        )
        []


{-| Takes out of the spell whatever its own house rules setting doesn't offer,
as a link from before a change, or an edited one, can carry.
-}
dropUnoffered : List Change -> Model -> Model
dropUnoffered changeList model =
    reset (affected changeList model.houseRules model) model


{-| Takes the given options out of the spell: every instance of a seed, a
seed factor from every instance of its seed, or a global factor.
-}
reset : List Option -> Model -> Model
reset options model =
    List.foldl resetOption model options


resetOption : Option -> Model -> Model
resetOption option model =
    case option of
        SeedOption seedId ->
            model.seedInstances
                |> List.filter (\inst -> inst.seedId == seedId)
                |> List.foldl (\inst -> SpellEdit.removeSeedInstance inst.instanceId) model

        SeedFactorOption seedId factorId ->
            model.seedInstances
                |> List.filter (\inst -> inst.seedId == seedId)
                |> List.foldl (\inst -> SpellEdit.setSeedFactor inst.instanceId factorId 0) model

        GlobalFactorOption factorId ->
            SpellEdit.removeGlobalFactor factorId model



-- ─── Names ───────────────────────────────────────────────────────────────────


{-| The option's name as the page shows it. A seed factor is prefixed with its
seed's name, since several seeds have factors with similar names.
-}
optionName : Option -> String
optionName option =
    case option of
        SeedOption seedId ->
            getSeed seedId |> Maybe.map .name |> Maybe.withDefault ""

        SeedFactorOption seedId factorId ->
            case getSeed seedId of
                Just seed ->
                    let
                        factorName =
                            (seed.universalFactors ++ List.concatMap .factors seed.modes)
                                |> List.filter (\sf -> sf.id == factorId)
                                |> List.head
                                |> Maybe.map .name
                                |> Maybe.withDefault factorId
                    in
                    seed.name ++ ": " ++ factorName

                Nothing ->
                    factorId

        GlobalFactorOption factorId ->
            getFactor factorId |> Maybe.map .name |> Maybe.withDefault ""
