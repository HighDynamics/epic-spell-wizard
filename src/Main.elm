module Main exposing (main)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( init, Cmd.none )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


type alias Model =
    { spellName : String }


type Msg
    = NoOp


init : Model
init =
    { spellName = "" }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view _ =
    div [ class "p-8 text-arcane-400 text-2xl font-bold" ]
        [ text "Epic Spell Wizard" ]
