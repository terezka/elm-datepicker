module DatePicker.Config exposing (..)

import Date exposing (Date)
import DatePicker.Style as Style
import DatePicker.Helpers as Helpers


type alias Config =
    { getStyle : Style.View -> List ( String, Bool )
    , defaultDate : Date
    }


setGetStyle : (Style.View -> List ( String, Bool )) -> Config -> Config
setGetStyle getStyle config =
    { config | getStyle = getStyle }


setDefaultDate : Date -> Config -> Config
setDefaultDate defaultDate config =
    { config | defaultDate = defaultDate }


defaultConfig : Config
defaultConfig =
    { getStyle = always []
    , defaultDate = Helpers.defaultDate
    }
