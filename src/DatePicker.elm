module DatePicker exposing (Model, Msg, view, init, update, getNow)

import Platform.Cmd as Cmd
import Html exposing (Html, text, div, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (classList)
import Date exposing (Date, toTime, fromTime, now, year, month, day)
import Task exposing (perform)
import Array exposing (initialize)
import DatePicker.Helpers as Helpers

import Debug


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
    div []
        [ viewYear model
        , viewMonth toParentMsg model
        , viewDays toParentMsg model
        ]


viewYear : Model -> Html a
viewYear model =
    div []
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
        div []
            [ span [ onClick prevMsg ] [ text "< " ]
            , text <| toString <| month model.suggesting
            , span [ onClick nextMsg ] [ text " >" ]
            ]


viewDays : (Msg -> a) -> Model -> Html a
viewDays toParentMsg model =
    let
        createDay =
            viewDay toParentMsg model

        daysInMonth' =
            Helpers.daysInMonth model.suggesting

        days =
            Array.toList <| Array.initialize daysInMonth' createDay
    in
        div []
            days


viewDay : (Msg -> a) -> Model -> Int -> Html a
viewDay toParentMsg model dayZero =
    let
        day =
            dayZero + 1

        date =
            Helpers.changeDay day model.suggesting

        msg =
            toParentMsg <| SetSelected date

        highlighted =
            Helpers.equals model.selected date

        classes =
            [ ( "DatePickerDay", True )
            , ( "DatePickerDayHighLight", highlighted )
            ]
    in
        div
            [ onClick msg
            , classList classes
            ]
            [ text <| toString <| day ]
