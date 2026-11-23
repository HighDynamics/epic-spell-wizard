module SpellEdit exposing (removeGlobalFactor, removeSeedInstance, setSeedFactor)

{-| Edits to the spell being built that more than one part of the app makes.
-}

import Types exposing (..)


{-| Removes a seed instance, moving the primary to the next one if needed.
Removing the last seed also drops the global factors and area shapes, since
they have nothing left to apply to.
-}
removeSeedInstance : SeedInstanceId -> Model -> Model
removeSeedInstance iid model =
    let
        remaining =
            List.filter (\i -> i.instanceId /= iid) model.seedInstances

        newPrimary =
            if model.primarySeedInstanceId == Just iid then
                List.head remaining |> Maybe.map .instanceId

            else
                model.primarySeedInstanceId
    in
    if List.isEmpty remaining then
        { model
            | seedInstances = remaining
            , primarySeedInstanceId = newPrimary
            , appliedFactors = []
            , targetToAreaShape = Nothing
            , personalToAreaShape = Nothing
            , boltShape = Nothing
        }

    else
        { model
            | seedInstances = remaining
            , primarySeedInstanceId = newPrimary
        }


{-| Sets a seed factor's quantity on one seed instance; 0 removes it.
-}
setSeedFactor : SeedInstanceId -> String -> Int -> Model -> Model
setSeedFactor iid factorId qty model =
    { model
        | seedInstances =
            List.map
                (\i ->
                    if i.instanceId == iid then
                        let
                            existing =
                                List.filter (\asf -> asf.factorId /= factorId) i.appliedSeedFactors

                            updated =
                                if qty > 0 then
                                    existing ++ [ { factorId = factorId, quantity = qty } ]

                                else
                                    existing
                        in
                        { i | appliedSeedFactors = updated }

                    else
                        i
                )
                model.seedInstances
    }


{-| Removes a global factor, along with the area shape it chose, if any.
-}
removeGlobalFactor : FactorId -> Model -> Model
removeGlobalFactor factorId model =
    { model
        | appliedFactors = List.filter (\af -> af.factorId /= factorId) model.appliedFactors
        , targetToAreaShape =
            if factorId == TargetToArea then
                Nothing

            else
                model.targetToAreaShape
        , personalToAreaShape =
            if factorId == PersonalToArea then
                Nothing

            else
                model.personalToAreaShape
        , boltShape =
            if factorId == ChangeToBolt then
                Nothing

            else
                model.boltShape
    }
