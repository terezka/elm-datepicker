module DatePicker exposing (Model, Msg, view, init, update, getNow)

import Platform.Cmd as Cmd
import Html exposing (Html, text)
import Date exposing (Date, toTime, fromTime, now)
import Task exposing (perform, map)


type alias Model =
    { suggesting : Date
    , selected : Date
    }


defaultDate : Date
defaultDate =
    fromTime 0


getNow : (Msg -> a) -> Cmd a
getNow toParentMsg =
    let
        failed =
            always SetSelected defaultDate

        succeded =
            SetSelected

        cmd =
            perform failed succeded Date.now
    in
        Cmd.map toParentMsg cmd


init : Model
init =
    { suggesting = defaultDate
    , selected = defaultDate
    }


initWithDate : Date -> Model
initWithDate date =
    { suggesting = date
    , selected = date
    }


type Msg
    = SetSuggesting Date
    | SetSelected Date


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetSuggesting date ->
            { model | suggesting = date }

        SetSelected date ->
            { model | selected = date }


view : String -> Html Msg
view output =
    text output
