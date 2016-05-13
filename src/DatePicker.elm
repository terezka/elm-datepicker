module DatePicker exposing (Model, Msg, view, init, initWithConfig, update, getNow)

import Platform.Cmd as Cmd
import Html exposing (Html, Attribute, text, div, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (classList, style)
import Date exposing (Date, toTime, fromTime, now, year, month, day)
import Task exposing (perform)
import Array exposing (initialize)
import DatePicker.Helpers as Helpers
import DatePicker.Style as Style
import DatePicker.Config as Config
import Debug


-- MODEL


type alias Model =
    { focused : Date
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
    { focused = Helpers.defaultDate
    , selected = Helpers.defaultDate
    , config = Config.defaultConfig
    }


initWithConfig : Config.Config -> Model
initWithConfig config =
    { focused = config.defaultDate
    , selected = config.defaultDate
    , config = config
    }



-- UPDATE


type Msg
    = SetFocused Date
    | SetSelected Date


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetFocused date ->
            { model | focused = date }

        SetSelected date ->
            { model | focused = date, selected = date }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ styling model Style.Container ]
        [ viewMonth model
        , viewWeekdays model
        , viewDays model
        ]


viewMonth : Model -> Html Msg
viewMonth model =
    let
        prevMonth =
            Helpers.addMonth -1 model.focused

        nextMonth =
            Helpers.addMonth 1 model.focused

        monthString =
            toString (month model.focused)
    in
        div
            [ styling model Style.MonthMenu ]
            [ div
                [ styling model Style.ArrowLeft
                , onClick (SetFocused prevMonth)
                ]
                [ span [ styling model Style.ArrowLeftInner ] [ text "" ] ]
            , span
                [ styling model Style.MonthContainer ]
                [ span [ styling model Style.Month ] [ text monthString ]
                , span [ styling model Style.Year ] [ text <| toString <| year model.focused ]
                ]
            , div
                [ styling model Style.ArrowRight
                , onClick (SetFocused nextMonth) ]
                [ span [ styling model Style.ArrowRightInner ] [ text "" ] ]
            ]


viewWeekdays : Model -> Html Msg
viewWeekdays model =
    let
      days = [ "Ma", "Tu", "We", "Th", "Fr", "Sa", "Su" ]

      createDay =
        (\day -> div [ styling model Style.DayType ] [ text day ])
    in
      div
          [ styling model Style.DayTypes ]
          (List.map createDay days)


viewDays : Model -> Html Msg
viewDays model =
    let
        createDay =
            viewDay model (Helpers.firstOfSlide model.focused)

        days =
            Array.toList (Array.initialize 42 createDay)
    in
        div
          [ styling model Style.Days ]
          days


viewDay : Model -> Date -> Int -> Html Msg
viewDay model init diff =
    let
        date =
            Helpers.addDay diff init

        highlighted =
            Helpers.equals model.selected date

        isNotCurrentMonth =
          month date /= month model.focused

        styling =
            if model.config.useDefaultStyles then
                Style.getDefaultStyle Style.Day
                |> (++) ((?) highlighted (Style.getDefaultStyle Style.DayHighlight))
                |> (++) ((?) isNotCurrentMonth (Style.getDefaultStyle Style.DayNotCurrentMonth))
                |> style
            else
                model.config.getClasses Style.Day
                |> (++) ((?) highlighted (model.config.getClasses Style.DayHighlight))
                |> (++) ((?) isNotCurrentMonth (model.config.getClasses Style.DayNotCurrentMonth))
                |> classList
    in
        div
            [ styling
            , onClick (SetSelected date)
            ]
            [ text (toString (day date)) ]



-- styling helpers


(?) : Bool -> List a -> List a
(?) condition ifTrue =
  if condition then ifTrue else []


styling : Model -> Style.View -> Attribute a
styling model view =
    if model.config.useDefaultStyles then
        style (Style.getDefaultStyle view)
    else
        classList (model.config.getClasses view)
