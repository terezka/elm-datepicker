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


view : Model -> Html Msg
view model =
    div
        [ classList <| getClasses model Style.Container ]
        [ viewMonth model
        , viewWeekdays model
        , viewDays model
        ]


viewMonth : Model -> Html Msg
viewMonth model =
    let
        prevMonth =
            Helpers.addMonth -1 model.suggesting

        nextMonth =
            Helpers.addMonth 1 model.suggesting

        monthString =
            toString (month model.suggesting)
    in
        div [ classList <| getClasses model Style.MonthMenu ]
            [ span
                [ onClick (SetSuggesting prevMonth)
                , classList <| getClasses model Style.ArrowLeft ]
                [ text "< " ]
            , span
                [ classList <| getClasses model Style.Month ]
                [ text monthString ]
            , span
                [ classList <| getClasses model Style.Year ]
                [ text <| toString <| year model.suggesting ]
            , span
                [ onClick (SetSuggesting nextMonth)
                , classList <| getClasses model Style.ArrowRight  ]
                [ text " >" ]
            ]


viewWeekdays : Model -> Html Msg
viewWeekdays model =
    let
      days = [ "Ma", "Tu", "We", "Th", "Fr", "Sa", "Su" ]

      createDay =
        (\day -> div [ classList (getClasses model Style.DayType) ] [ text day ] )
    in
    div
        [ classList (getClasses model Style.DayTypes) ]
        (List.map createDay days)


viewDays : Model -> Html Msg
viewDays model =
    let
        createDay =
            viewDay model (Helpers.firstOfSlide model.suggesting)

        days =
            Array.toList (Array.initialize 42 createDay)
    in
        div
          [ classList (getClasses model Style.Days) ]
          days


viewDay : Model -> Date -> Int -> Html Msg
viewDay model init diff =
    let
        date =
            Helpers.addDay diff init

        highlighted =
            Helpers.equals model.selected date

        highlightClasses =
            if highlighted then
                getClasses model Style.DayHighlight
            else
                []

        isCurrentMonth =
          month date == month model.suggesting

        notCurrentMonthClasses =
            if isCurrentMonth then
              []
            else
              getClasses model Style.DayNotCurrentMonth
    in
        div
            [ onClick (SetSelected date)
            , classList (getClasses model Style.Day ++ highlightClasses ++ notCurrentMonthClasses)
            ]
            [ text (toString (day date)) ]


getClasses : Model -> Style.View -> List ( String, Bool )
getClasses model view =
    let
      custom =
        model.config.getClasses view

      default =
        Style.getDefaultClasses view
    in
      if List.isEmpty custom then default else custom
