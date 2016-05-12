module DatePicker.Config exposing (..)

import Date exposing (Date)
import DatePicker.Style as Style
import DatePicker.Helpers as Helpers


type alias Config =
    { getClasses : Style.View -> List ( String, Bool )
    , defaultDate : Date
    }


setGetClasses : (Style.View -> List ( String, Bool )) -> Config -> Config
setGetClasses getClasses config =
    { config | getClasses = getClasses }


setDefaultDate : Date -> Config -> Config
setDefaultDate defaultDate config =
    { config | defaultDate = defaultDate }


defaultConfig : Config
defaultConfig =
    { getClasses = always []
    , defaultDate = Helpers.defaultDate
    }
