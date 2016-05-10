module DatePicker exposing (view, Msg, init)

import Html exposing (Html, text)
import Date exposing (Date)


type alias Model = 
  { suggesting : Date
  , selected : Date
  }


init : Date -> Model
init date =
  { suggesting = date
  , selected = date 
  }


type Msg 
  = SetSuggesting Date 
  | SetSelected Date


update : Msg -> Model -> Model
update msg model = 
  case msg of
    SetSuggesting date ->
      { model | suggesting = date }

    SetSelected date ->
      { model | selected = date }


view : String -> Html Msg
view output =
  text output