module DatePicker exposing (Model, Msg, view, init, update, getNow)

import Platform.Cmd as Cmd
import Html exposing (Html, text, div, span)
import Html.Events exposing (onClick)
import Date exposing (Date, toTime, fromTime, now, year, month, day)
import Task exposing (perform, map)

import DatePicker.Helpers as Helpers


-- MODEL


type alias Model =
    { suggesting : Date
    , selected : Date
    }


getNow : (Msg -> a) -> Cmd a
getNow toParentMsg =
    let
        failed =
            always SetSelected Helpers.defaultDate

        succeded =
            SetSelected

        cmd =
            perform failed succeded Date.now
    in
        Cmd.map toParentMsg cmd


init : Model
init =
    { suggesting = Helpers.defaultDate
    , selected = Helpers.defaultDate
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
      , viewMonth toParentMsg model
      , viewDays model
      ]
    

viewYear : Model -> Html a
viewYear model =
    div 
      []
      [ text <| toString <| year model.suggesting ]


viewMonth : (Msg -> a) -> Model -> Html a 
viewMonth toParentMsg model =
    let 
      toMsg =
        SetSuggesting >> toParentMsg
      
      prevMsg = 
        Helpers.addMonth -1 model.suggesting |> toMsg

      nextMsg = 
        Helpers.addMonth 1 model.suggesting |> toMsg
      
    in 
      div 
        []
        [ span [ onClick prevMsg ] [ text "< " ]
        , text <| toString <| month model.suggesting
        , span [ onClick nextMsg ] [ text " >" ]
        ]


viewDays : Model -> Html a 
viewDays model =
    let 
      daysInMonth' = Helpers.daysInMonth model.suggesting
    in
      div 
        []
        [ text <| toString <| day model.suggesting
        , div [] [ text <| toString <| Helpers.daysInMonth model.suggesting ] 
        ]


