program Eta;

{$APPTYPE CONSOLE}

uses
  SysUtils, DateUtils;

function Eta(Nascita, Oggi: TDate): Integer;
begin
  Result := YearOf(Oggi) - YearOf(Nascita);
  if (MonthOf(Oggi) < MonthOf(Nascita)) or
     ((MonthOf(Oggi) = MonthOf(Nascita)) and
      (DayOf(Oggi) < DayOf(Nascita))) then
    Dec(Result);
end;

begin
  WriteLn(Eta(EncodeDate(1990, 7, 3),
    EncodeDate(2026, 7, 2)));
  WriteLn(Eta(EncodeDate(1990, 7, 3),
    EncodeDate(2026, 7, 3)));
  WriteLn(Eta(EncodeDate(2000, 2, 29),
    EncodeDate(2026, 2, 28)));
end.
