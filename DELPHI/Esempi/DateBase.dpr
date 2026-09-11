program DateBase;

{$APPTYPE CONSOLE}

uses
  SysUtils, DateUtils;

var
  D, D2: TDateTime;
  A, M, G, H, Mi, S, Ms: Word;
begin
  D := EncodeDate(2026, 3, 15) + EncodeTime(14, 30, 0, 0);
  WriteLn(D:0:4);
  WriteLn(Trunc(D), ' ', Frac(D):0:4);
  DecodeDate(D, A, M, G);
  DecodeTime(D, H, Mi, S, Ms);
  WriteLn(A, '-', M, '-', G, ' ', H, ':', Mi);
  D2 := D + 1.5;
  WriteLn(D2 - D:0:1, ' ', D2 > D);
  WriteLn(DateOf(D2) - DateOf(D):0:0);
  WriteLn(YearOf(D), ' ', MonthOf(D), ' ', DayOf(D), ' ',
    HourOf(D));
  WriteLn(DayOfTheWeek(D), ' ', DayOfWeek(D));
end.
