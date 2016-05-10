import Html exposing (Html, button, div, text)
import Html.App as Html
import Html.Events exposing (onClick)
import Platform.Sub as Sub
import Platform.Cmd as Cmd
import Task exposing (perform)

--import DatePicker exposing (view, init, Msg)
import Date exposing (Date, now, toTime)


main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL



type alias Model =
  { date : Int }


nowCmd : Cmd Msg
nowCmd =
  let 
    failed = 
      always SetDate 0

    succeded =
      toTime >> floor >> SetDate
  in
    perform failed succeded now


init : (Model, Cmd Msg)
init =
  (Model 0, nowCmd)



-- UPDATE



type Msg = SetDate Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetDate date ->
      (Model date, Cmd.none)



-- SUBSCRIPTIONS



subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div 
    []
    [ text ("now: " ++ (toString model.date)) ]


