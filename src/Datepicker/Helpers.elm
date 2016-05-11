module DatePicker.Helpers exposing (defaultDate, addMonth, daysInMonth)

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

    in
      assemble 1 month1 year1
        |> fromString
        |> Result.withDefault defaultDate


daysInMonth : Date -> Int
daysInMonth date =
    let 
      year' = year date
      month' = month date
    in
      case month' of
        Date.Feb ->
          if year'%4==0 && year'%100/=0 || year'%400==0 then
            29
          else 
            28
        Date.Apr -> 30
        Date.Jun -> 30
        Date.Sep -> 30
        Date.Nov -> 30
        _ -> 31


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


