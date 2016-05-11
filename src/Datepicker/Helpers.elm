module DatePicker.Helpers exposing (defaultDate, addMonth)

import Date exposing (Date, Month, fromTime, fromString, year, month)
import Result exposing (withDefault)
import Debug

defaultDate : Date
defaultDate =
    fromTime 0


assemble : Int -> Int -> Int -> String
assemble day month year =
  (toString month)++"/"++(toString day)++"/"++(toString year)



-- Handle months


addMonth : Int -> Date -> Date
addMonth diff date =
    let
      month0 = 
        month date
        |> monthAsInt 
        |> (+) diff 

      month1 =
        if month0 > 12 then
          month0 - 12
        else if month0 < 1 then
          12 - (abs month0)
        else 
          month0

      year0 =
        year date

      year1 =
        if month0 > 12 then
          year0 + 1
        else if month0 < 1 then
          year0 - 1
        else 
          year0

      test =
        month0
        |> Debug.log "month0"
    in
      assemble 1 month1 year1
        |> Debug.log "assembled"
        |> fromString
        |> Result.withDefault defaultDate


monthAsInt : Month -> Int
monthAsInt month =
    case month of 
      Date.Jan -> 1
      Date.Feb -> 2
      Date.Mar -> 3
      Date.Apr -> 4
      Date.May -> 5
      Date.Jun -> 6
      Date.Jul -> 7
      Date.Aug -> 8
      Date.Sep -> 9
      Date.Oct -> 10
      Date.Nov -> 11
      Date.Dec -> 12



