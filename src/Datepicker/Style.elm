module DatePicker.Style exposing (..)


type View
    = Container
    | MonthMenu
    | MonthContainer
    | Month
    | Year
    | ArrowLeft
    | ArrowLeftInner
    | ArrowRight
    | ArrowRightInner
    | DayTypes
    | DayType
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

        Year ->
            [ ( "padding", "0 0.25em" ) ]

        MonthMenu ->
            [ ( "text-align", "center" )
            , ( "border", "1px solid rgb(224, 224, 224)" )
            , ( "margin-bottom", "-1px" )
            , ( "padding", "0.5em 0.5em 0.75em 0.5em" )
            , ( "margin-right", "6px" )
            ]

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

        DayType ->
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
            [ ( "background-color", "rgb(224, 224, 224)" ) ]

        DayNotCurrentMonth ->
            [ ( "opacity", "0.5" ) ]

        _ ->
            []
