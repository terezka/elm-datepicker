module DatePicker exposing (Model, Msg, view, init, initWithConfig, update, getNow)

import Platform.Cmd as Cmd
import Html exposing (Html, Attribute, text, div, span, input, label)
import Html.Events exposing (onClick)
import Html.Attributes exposing (classList, style, type_, value, maxlength)
import Date exposing (Date, toTime, fromTime, now, year, month, day)
import Task exposing (perform)
import Array exposing (initialize)
import DatePicker.Helpers as Helpers
import DatePicker.Style as Style
import DatePicker.Config as Config


-- MODEL


type Choice
    = Start
    | End
    | None


type alias Model =
    { focused : Date
    , choice : Choice
    , selected : Maybe Date
    , selectedEnd : Maybe Date
    , config : Config.Config
    }


getNow : (Msg -> msg) -> Cmd msg
getNow tagger =
    perform (tagger << SetFocused) Date.now


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
                            case result of
                                Just date ->
                                    if Helpers.isBefore selected date then
                                        { model | selected = Just date, selectedEnd = Nothing }
                                    else
                                        { model | selectedEnd = Just date }

                                Nothing ->
                                    { model | selectedEnd = Nothing }

                        Nothing ->
                            { model | selectedEnd = result, choice = Start }

                None ->
                    model



-- VIEW


view : Model -> Html Msg
view model =
    div [ styling model Style.Container ]
        [ viewInputs model, viewDatepicker model ]


viewInputs : Model -> Html Msg
viewInputs model =
    let
        inputs =
            if model.config.useRange then
                [ viewInput model Start, viewInput model End ]
            else
                [ viewInput model Start ]
    in
        div [ styling model Style.InputsContainer ] inputs


viewInput : Model -> Choice -> Html Msg
viewInput model choice =
    let
        value_ =
            case choice of
                Start ->
                    model.selected

                End ->
                    model.selectedEnd

                None ->
                    Just Helpers.defaultDate

        placeholder =
            case choice of
                Start ->
                    model.config.placeholderFrom

                End ->
                    model.config.placeholderTo

                None ->
                    ""
    in
        div [ styling model Style.InputContainer, onClick (SetSelecting choice) ]
            [ label [ styling model Style.InputLabel ]
                [ span [] []
                , input [ styling model Style.Input, type_ "text", maxlength 10 ] []
                ]
            , div [ styling model Style.InputDisplayTextContainer ]
                [ span [ styling model Style.InputDisplayText ] [ text (Helpers.dateAsString placeholder value_) ] ]
            ]


viewDatepicker : Model -> Html Msg
viewDatepicker model =
    div
        [ styling model Style.DatepickerContainer ]
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
        div [ styling model Style.MonthMenu ]
            [ div [ styling model Style.ArrowLeft, onClick (SetFocused prevMonth) ]
                [ span [ styling model Style.ArrowLeftInner ] [] ]
            , span [ styling model Style.MonthContainer ]
                [ span [ styling model Style.Month ] [ text monthString ]
                , span [ styling model Style.Year ] [ text <| toString <| year model.focused ]
                ]
            , div [ styling model Style.ArrowRight, onClick (SetFocused nextMonth) ]
                [ span [ styling model Style.ArrowRightInner ] [] ]
            ]


viewWeekdays : Model -> Html Msg
viewWeekdays model =
    let
        days =
            [ "Mo", "Tu", "We", "Th", "Fr", "Sa", "Su" ]

        createDay day =
            div [ styling model Style.WeekDay ] [ text day ]
    in
        div [ styling model Style.WeekDays ]
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
                    case model.selectedEnd of
                        Just selectedEnd ->
                            Helpers.isBetween selected selectedEnd date

                        Nothing ->
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
    in
        div [ styling, onClick (SetSelected model.choice <| Just date) ]
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
