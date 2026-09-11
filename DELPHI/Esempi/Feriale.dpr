program Feriale;

{$APPTYPE CONSOLE}

uses
  SysUtils, DateUtils;

function ProssimoFeriale(D: TDate): TDate;
begin
  Result := D;
  while DayOfTheWeek(Result) > 5 do
    Result := IncDay(Result, 1);
end;

const
  F = 'ddd yyyy-mm-dd';
begin
  WriteLn(FormatDateTime(F,
    ProssimoFeriale(EncodeDate(2026, 3, 13))));
  WriteLn(FormatDateTime(F,
    ProssimoFeriale(EncodeDate(2026, 3, 14))));
  WriteLn(FormatDateTime(F,
    ProssimoFeriale(EncodeDate(2026, 3, 15))));
end.
