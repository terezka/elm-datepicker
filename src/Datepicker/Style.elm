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


getDefaultStyle : View -> List ( String, Bool )
getDefaultStyle view =
    case view of
        Container ->
            [ ("datepicker", True) ]

        Year ->
            [ ("datepicker__year", True) ]

        MonthMenu ->
            [ ("datepicker__month-menu", True) ]

        Month ->
            [ ("datepicker__month-menu__menu", True ) ]

        ArrowLeft ->
            [ ("datepicker__month-menu__arrow-left", True) ]

        ArrowRight ->
            [ ("datepicker__month-menu__arrow-right", True) ]

        DayTypes ->
            [ ("datepicker__day-types", True ) ]

        DayType ->
            [ ("datepicker__day-types__day", True ) ]

        Days ->
            [ ("datepicker__days", True) ]

        Day ->
            [ ("datepicker__day", True) ]

        DayHighlight ->
            [ ("datepicker__day--highlight", True) ]

        DayNotCurrentMonth ->
            [ ("datepicker__day--not-current", True) ]
