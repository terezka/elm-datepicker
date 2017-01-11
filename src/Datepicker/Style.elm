module DatePicker.Style exposing (..)


type View
    = Container
    | InputsContainer
    | InputContainer
    | InputLabel
    | Input
    | InputDisplayTextContainer
    | InputDisplayText
    | DatepickerContainer
    | MonthMenu
    | MonthContainer
    | Month
    | Year
    | ArrowLeft
    | ArrowLeftInner
    | ArrowRight
    | ArrowRightInner
    | WeekDays
    | WeekDay
    | Days
    | Day
    | DayHighlight
    | DayNotCurrentMonth


getDefaultStyle : View -> List ( String, String )
getDefaultStyle view =
    case view of
        Container ->
            [ ( "padding", "0.25em" )
            , ( "width", "300px" )
            , ( "border-radius", "2px" )
            , ( "text-align", "center" )
            , ( "box-sizing", "border-box" )
            ]

        InputsContainer ->
            [ ( "position", "relative" )
            , ( "height", "100%" )
            , ( "box-sizing", "border-box" )
            ]

        InputContainer ->
            [ ( "position", "relative" )
            , ( "display", "inline-block" )
            , ( "height", "100%" )
            , ( "width", "50%" )
            , ( "box-sizing", "border-box" )
            ]

        InputLabel ->
            [ ( "opacity", "0" )
            ]

        Input ->
            [ ( "display", "block" )
            , ( "padding", "8px 10px" )
            , ( "height", "44px" )
            , ( "box-sizing", "border-box" )
            , ( "text-align", "center" )
            , ( "margin", "0" )
            , ( "border", "0" )
            ]

        InputDisplayTextContainer ->
            [ ( "position", "absolute" )
            , ( "top", "0" )
            , ( "left", "0" )
            , ( "box-sizing", "border-box" )
            , ( "cursor", "pointer" )
            , ( "width", "100%" )
            , ( "margin-right", "6px" )
            ]

        InputDisplayText ->
            [ ( "margin", "6px" )
            , ( "padding", "4px 8px" )
            , ( "height", "30px" )
            , ( "box-sizing", "border-box" )
            , ( "font-size", "16px" )
            , ( "float", "left" )
            ]

        DatepickerContainer ->
            [ ( "padding", "0.25em" )
            , ( "width", "300px" )
            , ( "border-radius", "2px" )
            , ( "text-align", "center" )
            , ( "box-sizing", "border-box" )
            , ( "overflow", "hidden" )
            ]

        MonthMenu ->
            [ ( "text-align", "center" )
            , ( "border", "1px solid rgb(224, 224, 224)" )
            , ( "margin-bottom", "-1px" )
            , ( "padding", "0.5em 0.5em 0.75em 0.5em" )
            , ( "margin-right", "6px" )
            ]

        Year ->
            [ ( "padding", "0 0.25em" ) ]

        ArrowLeft ->
            [ ( "float", "left" )
            , ( "margin-top", "-2px" )
            , ( "cursor", "pointer" )
            ]

        ArrowLeftInner ->
            [ ( "width", "0px" )
            , ( "height", "0px" )
            , ( "font-size", "1px" )
            , ( "border-top", "6px solid transparent" )
            , ( "border-bottom", "6px solid transparent" )
            , ( "border-right", "11px solid rgb(102, 102, 102)" )
            , ( "border-radius", "2px" )
            , ( "vertical-align", "middle" )
            ]

        ArrowRight ->
            [ ( "float", "right" )
            , ( "margin-top", "-2px" )
            , ( "cursor", "pointer" )
            ]

        ArrowRightInner ->
            [ ( "width", "0px" )
            , ( "height", "0px" )
            , ( "font-size", "1px" )
            , ( "border-top", "6px solid transparent" )
            , ( "border-bottom", "6px solid transparent" )
            , ( "border-left", "11px solid rgb(102, 102, 102)" )
            , ( "border-radius", "2px" )
            , ( "vertical-align", "middle" )
            ]

        WeekDay ->
            [ ( "width", "14.28%" )
            , ( "box-sizing", "border-box" )
            , ( "display", "inline-block" )
            , ( "text-align", "center" )
            , ( "border", "1px solid rgb(224, 224, 224)" )
            , ( "margin-right", "-1px" )
            , ( "margin-bottom", "-1px" )
            , ( "padding", "0.25em" )
            , ( "float", "left" )
            ]

        Day ->
            [ ( "width", "14.28%" )
            , ( "box-sizing", "border-box" )
            , ( "display", "inline-block" )
            , ( "text-align", "center" )
            , ( "border", "1px solid rgb(224, 224, 224)" )
            , ( "margin-right", "-1px" )
            , ( "margin-bottom", "-1px" )
            , ( "padding", "0.25em" )
            , ( "float", "left" )
            , ( "cursor", "pointer" )
            ]

        DayHighlight ->
            [ ( "background-color", "rgb(234, 234, 234)" ) ]

        DayNotCurrentMonth ->
            [ ( "opacity", "0.5" ) ]

        _ ->
            []
