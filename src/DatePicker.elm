module DatePicker exposing (Model, Msg, view, init, initWithConfig, update, getNow)

import Platform.Cmd as Cmd
import Html exposing (Html, Attribute, text, div, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (classList)
import Date exposing (Date, toTime, fromTime, now, year, month, day)
import Task exposing (perform)
import Array exposing (initialize)
import DatePicker.Helpers as Helpers
import DatePicker.Style as Style
import DatePicker.Config as Config
import Debug


-- MODEL


type alias Model =
    { suggesting : Date
    , selected : Date
    , config : Config.Config
    }


getNow : (Msg -> a) -> Cmd a
getNow toParentMsg =
    let
        failed =
            (\_ -> SetSelected Helpers.defaultDate)

        cmd =
            perform failed SetSelected Date.now
    in
        Cmd.map toParentMsg cmd


init : Model
init =
    { suggesting = Helpers.defaultDate
    , selected = Helpers.defaultDate
    , config = Config.defaultConfig
    }


initWithConfig : Config.Config -> Model
initWithConfig config =
    { suggesting = config.defaultDate
    , selected = config.defaultDate
    , config = config
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
        [ classList <| getStyle model Style.Container ]
        [ viewMonth toParentMsg model
        , viewWeekdays model
        , viewDays toParentMsg model
        ]


viewMonth : (Msg -> a) -> Model -> Html a
viewMonth toParentMsg model =
    let
        toMsg =
            SetSuggesting >> toParentMsg

        prevMonth =
            Helpers.addMonth -1 model.suggesting

        nextMonth =
            Helpers.addMonth 1 model.suggesting

        monthString =
            toString (month model.suggesting)
    in
        div [ classList <| getStyle model Style.MonthMenu ]
            [ span
                [ onClick (toMsg prevMonth)
                , classList <| getStyle model Style.ArrowLeft ]
                [ text "< " ]
            , span
                [ classList <| getStyle model Style.Month ]
                [ text monthString ]
            , span
                [ classList <| getStyle model Style.Year ]
                [ text <| toString <| year model.suggesting ]
            , span
                [ onClick (toMsg nextMonth)
                , classList <| getStyle model Style.ArrowRight  ]
                [ text " >" ]
            ]


viewWeekdays : Model -> Html a
viewWeekdays model =
    let
      days = [ "Ma", "Tu", "We", "Th", "Fr", "Sa", "Su" ]

      createDay =
        (\day -> div [ classList (getStyle model Style.DayType) ] [ text day ] )
    in
    div
        [ classList (getStyle model Style.DayTypes) ]
        (List.map createDay days)


viewDays : (Msg -> a) -> Model -> Html a
viewDays toParentMsg model =
    let
        createDay =
            viewDay toParentMsg model (Helpers.firstOfSlide model.suggesting)

        days =
            Array.toList (Array.initialize 42 createDay)
    in
        div
          [ classList (getStyle model Style.Days) ]
          days


viewDay : (Msg -> a) -> Model -> Date -> Int -> Html a
viewDay toParentMsg model init diff =
    let
        date =
            Helpers.addDay diff init

        msg =
            toParentMsg (SetSelected date)

        highlighted =
            Helpers.equals model.selected date

        highlightClasses =
            if highlighted then
                getStyle model Style.DayHighlight
            else
                []

        isCurrentMonth =
          month date == month model.suggesting

        notCurrentMonthClasses =
            if isCurrentMonth then
              []
            else
              getStyle model Style.DayNotCurrentMonth
    in
        div
            [ onClick msg
            , classList (getStyle model Style.Day ++ highlightClasses ++ notCurrentMonthClasses)
            ]
            [ text (toString (day date)) ]


getStyle : Model -> Style.View -> List ( String, Bool )
getStyle model view =
    let
      custom =
        model.config.getStyle view

      default =
        Style.getDefaultStyle view
    in
      if List.isEmpty custom then default else custom
