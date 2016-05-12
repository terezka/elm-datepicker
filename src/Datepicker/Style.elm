module DatePicker.Style exposing (..)

type View
    = Container
    | Year
    | MonthMenu 
    | Day
    | DayHighlight


getDefaultStyle : View -> List (String, String)
getDefaultStyle view =
    case view of 
        Container ->
            [ ("padding", "0.25em") 
            , ("width", "300px")
            ]

        Year -> 
            [ ("text-align", "center")]

        MonthMenu ->
            [ ("text-align", "center")]

        Day ->
            [ ("width", "14.28%") 
            , ("display", "inline-block")
            , ("text-align", "center")
            ]

        DayHighlight ->
            [ ("color", "red")]
