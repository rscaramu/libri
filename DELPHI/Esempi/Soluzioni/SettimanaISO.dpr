program SettimanaISO;

{$APPTYPE CONSOLE}

uses
  SysUtils, DateUtils;

function SettimanaISO(D: TDate): Integer;
var
  Giovedi: TDate;
begin
  Giovedi := IncDay(D, 4 - DayOfTheWeek(D));
  Result := (DayOfTheYear(Giovedi) - 1) div 7 + 1;
end;

var
  A: Integer;
  D: TDate;
begin
  for A := 2020 to 2027 do
  begin
    D := EncodeDate(A, 1, 1);
    WriteLn(A, ': ', SettimanaISO(D), ' = ',
      WeekOfTheYear(D));
  end;
end.
