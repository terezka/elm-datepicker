module DatepickerExample exposing (..)

import Html exposing (Html, button, div, text, span)
import Html.App as App
import Html.Events exposing (onClick)
import Platform.Sub as Sub
import Platform.Cmd as Cmd
import Date exposing (fromTime, day)
import DatePicker
import DatePicker.Config as Config
import DatePicker.Style as Style


main =
    App.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { datepicker : DatePicker.Model }


init : ( Model, Cmd Msg )
init =
    let
        config =
            Config.defaultConfig
                |> Config.setGetClasses getClasses
                |> Config.setUseRange True
    in
        ( Model (DatePicker.initWithConfig config), DatePicker.getNow DatePicker )


init2 : ( Model, Cmd Msg )
init2 =
    let
        config =
            Config.defaultConfig
                |> Config.setGetClasses getClasses
                |> Config.setDefaultDate (fromTime 989887877676)
    in
        ( Model (DatePicker.initWithConfig config), Cmd.none )


getClasses : Style.View -> List ( String, Bool )
getClasses view =
    case view of
        Style.Year ->
            [ ( "lalalaladfdsf", True ) ]

        Style.DayHighlight ->
            [ ( "lalala2", True ) ]

        _ ->
            []



-- UPDATE


type Msg
    = DatePicker DatePicker.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DatePicker act ->
            let
                model =
                    { model | datepicker = DatePicker.update act model.datepicker }
            in
                ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ App.map DatePicker (DatePicker.view model.datepicker) ]
