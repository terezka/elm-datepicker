module DatePicker exposing (Model, Msg, view, init, update, getNow)

import Platform.Cmd as Cmd
import Html exposing (Html, text, div, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Date exposing (Date, toTime, fromTime, now, year, month, day)
import Task exposing (perform)
import Array exposing (initialize)

import DatePicker.Helpers as Helpers
import DatePicker.Style as Style

import Debug


-- MODEL


type alias Model =
    { suggesting : Date
    , selected : Date
    }


getNow : (Msg -> a) -> Cmd a
getNow toParentMsg =
    let failed = (\_ -> SetSelected Helpers.defaultDate)
        cmd = perform failed SetSelected Date.now
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
        [ style Style.datepicker ]
        [ viewYear model
        , viewMonth toParentMsg model
        , viewDays toParentMsg model
        ]


viewYear : Model -> Html a
viewYear model =
    div [ style Style.year ] [ text <| toString <| year model.suggesting ]


viewMonth : (Msg -> a) -> Model -> Html a
viewMonth toParentMsg model =
    let toMsg = SetSuggesting >> toParentMsg
        prevMonth = Helpers.addMonth -1 model.suggesting
        nextMonth = Helpers.addMonth  1 model.suggesting
        monthString = toString (month model.suggesting)
    in
        div 
            [ style Style.monthMenu ]
            [ span [ onClick (toMsg prevMonth) ] [ text "< " ]
            , text monthString
            , span [ onClick (toMsg nextMonth) ] [ text " >" ]
            ]


viewDays : (Msg -> a) -> Model -> Html a
viewDays toParentMsg model =
    let date = model.suggesting
        daysInMonth' = Helpers.daysInMonth date
        createDay = (\int -> viewDay toParentMsg model date (int+1))
        days = Array.toList <| Array.initialize daysInMonth' createDay
    in
        div [] days


viewDay : (Msg -> a) -> Model -> Date -> Int -> Html a
viewDay toParentMsg model init day =
    let date = Helpers.changeDay day model.suggesting
        msg = toParentMsg (SetSelected date)
        highlighted = Helpers.equals model.selected date
    in
        div
            [ onClick msg
            , style Style.day
            ]
            [ text (toString day) ]
