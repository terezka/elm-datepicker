module DatePicker.Config exposing (..)

import Date exposing (Date)
import DatePicker.Style as Style
import DatePicker.Helpers as Helpers


type alias Config =
    { getClasses : Style.View -> List ( String, Bool )
    , useDefaultStyles : Bool
    , defaultDate : Date
    , useRange : Bool
    , placeholderFrom : String
    , placeholderTo : String
    }


setGetClasses : (Style.View -> List ( String, Bool )) -> Config -> Config
setGetClasses getClasses config =
    { config | getClasses = getClasses }


setUseDefaultStyles : Bool -> Config -> Config
setUseDefaultStyles useDefaultStyles config =
    { config | useDefaultStyles = useDefaultStyles }


setDefaultDate : Date -> Config -> Config
setDefaultDate defaultDate config =
    { config | defaultDate = defaultDate }


setUseRange : Bool -> Config -> Config
setUseRange useRange config =
    { config | useRange = useRange }


defaultConfig : Config
defaultConfig =
    { getClasses = always []
    , useDefaultStyles = True
    , defaultDate = Helpers.defaultDate
    , useRange = False
    , placeholderFrom = "From"
    , placeholderTo = "To"
    }
