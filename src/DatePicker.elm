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

type Choice = Start | End | None


type alias Model =
    { focused : Date
    , choice : Choice
    , selected : Maybe Date
    , selectedEnd : Maybe Date
    , config : Config.Config
    }


getNow : (Msg -> a) -> Cmd a
getNow toParentMsg =
    let
        failed =
            (\_ -> SetFocused Helpers.defaultDate)

        cmd =
            perform failed SetFocused Date.now
    in
        Cmd.map toParentMsg cmd


init : Model
init =
    { focused = Helpers.defaultDate
    , choice = Start
    , selected = Nothing
    , selectedEnd = Nothing
    , config = Config.defaultConfig
    }


initWithConfig : Config.Config -> Model
initWithConfig config =
    { focused = config.defaultDate
    , choice = Start
    , selected = Nothing
    , selectedEnd = Nothing
    , config = config
    }



-- UPDATE


type Msg
    = SetFocused Date
    | SetSelecting Choice
    | SetSelected Choice (Maybe Date)


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetFocused date ->
            { model | focused = date }

        SetSelecting choice ->
            { model | choice = choice }

        SetSelected choice result ->
            case choice of
                Start ->
                    case model.selectedEnd of
                        Just selectedEnd ->
                            case result of
                                Just date ->
                                    if Helpers.isBefore selectedEnd date then
                                        { model | selected = Just date }
                                    else
                                        { model | selected = Just date, selectedEnd = Nothing }

                                Nothing ->
                                    { model | selected = Nothing }

                        Nothing ->
                            { model | selected = result, choice = End }

                End ->
                    case model.selected of
                        Just selected ->
                            { model | selectedEnd = result }

                        Nothing ->
                            { model | selectedEnd = result, choice = Start }
                None ->
                    model




-- VIEW


view : Model -> Html Msg
view model =
    let
        selected =
            div
                [ onClick (SetSelecting Start) ]
                [ text (Helpers.dateAsString model.selected) ]

        selectedEnd =
            div
                [ onClick (SetSelecting End) ]
                [ text (Helpers.dateAsString model.selectedEnd) ]

        datepicker =
            div
                [ styling model Style.Container ]
                [ viewMonth model
                , viewWeekdays model
                , viewDays model
                ]

        children =
          if model.config.useRange then [ selected, selectedEnd, datepicker ] else [ selected, datepicker ]
    in
        div [] children



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
        div [ styling model Style.MonthMenu ]
            [ div
                [ styling model Style.ArrowLeft
                , onClick (SetFocused prevMonth)
                ]
                [ span [ styling model Style.ArrowLeftInner ] [ ] ]
            , span [ styling model Style.MonthContainer ]
                [ span [ styling model Style.Month ] [ text monthString ]
                , span [ styling model Style.Year ] [ text <| toString <| year model.focused ]
                ]
            , div
                [ styling model Style.ArrowRight
                , onClick (SetFocused nextMonth)
                ]
                [ span [ styling model Style.ArrowRightInner ] [ ] ]
            ]


viewWeekdays : Model -> Html Msg
viewWeekdays model =
    let
        days =
            [ "Ma", "Tu", "We", "Th", "Fr", "Sa", "Su" ]

        createDay =
            (\day -> div [ styling model Style.DayType ] [ text day ])
    in
        div [ styling model Style.DayTypes ]
            (List.map createDay days)


viewDays : Model -> Html Msg
viewDays model =
    let
        createDay =
            viewDay model (Helpers.firstOfSlide model.focused)

        days =
            Array.toList (Array.initialize 42 createDay)
    in
        div [ styling model Style.Days ]
            days


viewDay : Model -> Date -> Int -> Html Msg
viewDay model init diff =
    let
        date =
            Helpers.addDay diff init

        highlighted =
            case model.selected of
                Just selected ->
                    Helpers.equals selected date
                Nothing ->
                    False


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

        choice =
            getChoice model date
    in
        div
            [ styling
            , onClick (SetSelected choice <| Just date)
            ]
            [ text (toString (day date)) ]



-- styling helpers + more


(?) : Bool -> List a -> List a
(?) condition ifTrue =
    if condition then
        ifTrue
    else
        []


styling : Model -> Style.View -> Attribute a
styling model view =
    if model.config.useDefaultStyles then
        style (Style.getDefaultStyle view)
    else
        classList (model.config.getClasses view)


getChoice : Model -> Date -> Choice
getChoice model date =
    case model.selected of
        Just selected ->
            case model.choice of
                End ->
                    if Helpers.isBefore selected date then Start else End
                _ ->
                    model.choice
        Nothing ->
            model.choice
