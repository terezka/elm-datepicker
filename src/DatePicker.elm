module DatePicker exposing (Model, Msg, view, init, update, getNow)

import Platform.Cmd as Cmd
import Html exposing (Html, text, div)
import Date exposing (Date, toTime, fromTime, now, year, month, day)
import Task exposing (perform, map)

import DatePicker.Helpers as Helpers


-- MODEL


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


-- UPDATE

type Msg
    = SetSuggesting Date
    | SetSelected Date


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetSuggesting date ->
            { model | suggesting = date }

        SetSelected date ->
            { model | suggesting = date, selected = date }



-- VIEW



view : (Msg -> a) -> Model -> Html a
view toParentMsg model =
    div 
      []
      [ viewYear model
      , viewMonth model
      , viewDay model
      ]
    

viewYear : Model -> Html a
viewYear model =
    div 
      []
      [ text <| toString <| year model.suggesting ]


viewMonth : Model -> Html a 
viewMonth model =
    div 
      []
      [ text <| toString <| month model.suggesting ]


viewDay : Model -> Html a 
viewDay model =
    div 
      []
      [ text <| toString <| day model.suggesting ]


