import Html exposing (Html, button, div, text)
import Html.App as Html
import Html.Events exposing (onClick)
import Platform.Sub as Sub
import Platform.Cmd as Cmd

import Debug

import DatePicker
import Date exposing (Date, now, toTime, fromTime)


main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL



type alias Model =
  { date : DatePicker.Model }


init : (Model, Cmd Msg)
init =
  (Model DatePicker.init, DatePicker.getNow DatePicker)



-- UPDATE



type Msg = DatePicker DatePicker.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    DatePicker act ->
      let
        model = { model | date = DatePicker.update act model.date }
      in
        (model, Cmd.none)



-- SUBSCRIPTIONS



subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div 
    []
    [ text ("now: " ++ (toString (toTime model.date.selected))) ]


