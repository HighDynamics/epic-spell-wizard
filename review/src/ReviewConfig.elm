module ReviewConfig exposing (config)

{-| elm-review configuration for Epic Spell Wizard.

Run with `npm run review`. Rules are grouped by package; see docs/ci-quality.md
for why these were chosen.

-}

import NoConfusingPrefixOperator
import NoMissingTypeAnnotation
import NoPrematureLetComputation
import NoUnused.CustomTypeConstructorArgs
import NoUnused.CustomTypeConstructors
import NoUnused.Dependencies
import NoUnused.Exports
import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import Review.Rule exposing (Rule)
import Simplify


config : List Rule
config =
    [ -- Dead code
      -- `Component` mirrors the full D&D spell-component list (V, S, M, DF, F,
      -- XP). No seed uses F or XP yet, but the type is deliberately complete,
      -- so this one rule is silenced for Types.elm rather than dropping them.
      NoUnused.CustomTypeConstructors.rule []
        |> Review.Rule.ignoreErrorsForFiles [ "src/Types.elm" ]
    , NoUnused.CustomTypeConstructorArgs.rule
    , NoUnused.Dependencies.rule
    , NoUnused.Exports.rule
    , NoUnused.Parameters.rule
    , NoUnused.Patterns.rule
    , NoUnused.Variables.rule

    -- Simplifications the compiler can't see
    , Simplify.rule Simplify.defaults

    -- Correctness / readability
    , NoMissingTypeAnnotation.rule
    , NoPrematureLetComputation.rule
    , NoConfusingPrefixOperator.rule
    ]
