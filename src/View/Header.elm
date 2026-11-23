module View.Header exposing (viewHeader)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Types exposing (..)
import View.Icons exposing (importIcon)



-- True if the spell has any content worth clearing — i.e. anything beyond
-- a freshly-started, blank spell.


hasSpellContent : Model -> Bool
hasSpellContent model =
    not (String.isEmpty model.spellName)
        || not (List.isEmpty model.seedInstances)
        || not (List.isEmpty model.appliedFactors)
        || model.selectedSchool
        /= Nothing
        || model.selectedSavingThrow
        /= Nothing
        || model.targetToAreaShape
        /= Nothing
        || model.personalToAreaShape
        /= Nothing
        || model.boltShape
        /= Nothing


viewHeader : Model -> Html Msg
viewHeader model =
    div [ class "flex items-center justify-between gap-2 px-4 md:px-6 py-3 bg-gray-900 border-b border-gray-700 shrink-0" ]
        [ h1 [ class "text-2xl font-bold text-arcane-400 tracking-wide" ] [ text "Epic Spell Wizard" ]
        , div [ class "flex items-center gap-1.5 md:gap-2 shrink-0" ]
            ((if model.isStandalone then
                [ button
                    [ class "hidden md:flex items-center gap-1.5 px-3 py-1.5 rounded border border-arcane-600 text-arcane-400 text-sm hover:bg-arcane-900"
                    , onClick ToggleImportModal
                    ]
                    [ importIcon "w-4 h-4", text "Import Spell" ]
                ]

              else
                []
             )
                ++ (case model.clearSpellUndo of
                        Just _ ->
                            [ button
                                [ class "px-2 md:px-3 py-1.5 rounded border border-arcane-600 text-arcane-400 text-sm whitespace-nowrap hover:bg-arcane-900"
                                , onClick UndoClearSpell
                                ]
                                [ text "Undo" ]
                            ]

                        Nothing ->
                            if hasSpellContent model then
                                [ button
                                    [ class "px-2 md:px-3 py-1.5 rounded border border-red-800/60 text-red-400/80 text-sm whitespace-nowrap hover:bg-red-900/20 hover:text-red-400"
                                    , attribute "aria-label" "Clear Spell"
                                    , onClick ClearSpell
                                    ]
                                    (shortOnPhones "Clear" "Clear Spell")
                                ]

                            else
                                []
                   )
                ++ [ viewHouseRulesSwitch model.houseRules
                   , button
                        [ class "px-2 md:px-3 py-1.5 rounded border border-arcane-600 text-arcane-400 text-sm whitespace-nowrap hover:bg-arcane-900"
                        , attribute "aria-label" "How does this work?"
                        , onClick ToggleHelpModal
                        ]
                        (shortOnPhones "?" "How does this work?")
                   ]
            )
        ]


viewHouseRulesSwitch : Bool -> Html Msg
viewHouseRulesSwitch isOn =
    let
        ( trackClass, knobClass, checkedValue ) =
            if isOn then
                ( "bg-arcane-500", "translate-x-3", "true" )

            else
                ( "bg-gray-600", "", "false" )
    in
    button
        [ class "flex items-center gap-1.5 md:gap-2 px-2 md:px-3 py-1.5 rounded border border-gray-700 text-gray-300 text-sm whitespace-nowrap hover:border-gray-500"
        , attribute "role" "switch"
        , attribute "aria-checked" checkedValue
        , title "Use the Sojourner Saga campaign's house rules"
        , onClick ToggleHouseRules
        ]
        [ span [ class ("relative inline-block w-7 h-4 rounded-full shrink-0 transition-colors " ++ trackClass) ]
            [ span [ class ("absolute top-0.5 left-0.5 w-3 h-3 rounded-full bg-gray-100 transition-transform " ++ knobClass) ] [] ]
        , text "House rules"
        ]



-- Phones show the short label so the header's controls fit on one row; the
-- button's aria-label keeps the full name for screen readers.


shortOnPhones : String -> String -> List (Html msg)
shortOnPhones short full =
    [ span [ class "md:hidden" ] [ text short ]
    , span [ class "hidden md:inline" ] [ text full ]
    ]
