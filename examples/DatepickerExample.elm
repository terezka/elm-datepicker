module DatepickerExample exposing (..)

import Html exposing (Html, button, div, text)
import Html.App as Html
import Html.Events exposing (onClick)
import Platform.Sub as Sub
import Platform.Cmd as Cmd

import Date exposing (fromTime)

import DatePicker
import DatePicker.Config as Config
import DatePicker.Style as Style


main =
    Html.program { init = init2, view = view, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { datepicker : DatePicker.Model }


init : ( Model, Cmd Msg )
init =
    let 
        config =
            Config.defaultConfig
            |> Config.setGetStyle getStyle
    in
        ( Model (DatePicker.initWithConfig config), DatePicker.getNow DatePicker )


init2 : ( Model, Cmd Msg )
init2 =
    let 
        config =
            Config.defaultConfig
            |> Config.setDefaultDate (fromTime 989887877676)
    in
        ( Model (DatePicker.initWithConfig config), Cmd.none )


getStyle : Style.View -> List (String, String)
getStyle view =
    case view of
        Style.Year ->
            [ ("color", "blue")]

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
        [ DatePicker.view DatePicker model.datepicker ]
