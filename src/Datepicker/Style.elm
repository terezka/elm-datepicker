module DatePicker.Style exposing (..)

datepicker : List (String, String)
datepicker = 
    [ ("padding", "0.25em") 
    , ("width", "300px")
    ]


year : List (String, String)
year =
    [ ("text-align", "center")]


monthMenu : List (String, String)
monthMenu =
    [ ("text-align", "center")]


day : List (String, String)
day = 
    [ ("width", "14.28%") 
    , ("display", "inline-block")
    , ("text-align", "center")
    ]


dayHighlight : List (String, String)
dayHighlight =
    [ ("color", "red")]