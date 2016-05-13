module DatePicker.Style exposing (..)


type View
    = Container
    | Year
    | MonthMenu
    | Month
    | ArrowLeft
    | ArrowRight
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
            , ( "border-radius", "2px")
            , ( "text-align", "center" )
            , ( "box-sizing", "border-box")
            ]

        Year ->
            [ ( "padding", "0 0.25em" ) ]

        MonthMenu ->
            [ ( "text-align", "center" )
            , ( "border", "1px solid rgb(224, 224, 224)")
            , ( "margin-bottom", "-1px")
            , ( "padding", "0.25em" )
            , ( "margin-right", "6px" )
            ]

        ArrowLeft ->
            [ ( "float", "left" )
            , ( "padding", "0 0.25em" )
            ]

        ArrowRight ->
            [ ( "float", "right" )
            , ( "padding", "0 0.25em" )
            ]

        Day ->
            [ ( "width", "14.28%" )
            , ( "box-sizing", "border-box")
            , ( "display", "inline-block" )
            , ( "text-align", "center" )
            , ( "border", "1px solid rgb(224, 224, 224)" )
            , ( "margin-right", "-1px" )
            , ( "margin-bottom", "-1px" )
            , ( "padding", "0.25em" )
            , ( "float", "left" )
            ]

        DayHighlight ->
            [ ( "color", "red" ) ]

        _ ->
          []
