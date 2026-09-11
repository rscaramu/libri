program Aritmetica;

{$APPTYPE CONSOLE}

uses
  SysUtils, DateUtils;

const
  F = 'yyyy-mm-dd';

var
  D, D2: TDateTime;
begin
  D := EncodeDate(2026, 1, 31);
  WriteLn(FormatDateTime(F, IncDay(D, 1)));
  WriteLn(FormatDateTime(F, IncMonth(D, 1)));
  WriteLn(FormatDateTime(F, IncYear(D, -1)));
  WriteLn(FormatDateTime(F, IncWeek(D, 2)));
  D2 := EncodeDate(2026, 12, 25);
  WriteLn(DaysBetween(D, D2), ' ', WeeksBetween(D, D2), ' ',
    MonthsBetween(D, D2));
  WriteLn(DaysBetween(D2, D));
  WriteLn(FormatDateTime(F, StartOfTheMonth(D2)), ' ',
    FormatDateTime(F, EndOfTheMonth(D2)));
  WriteLn(FormatDateTime(F, StartOfTheYear(D2)), ' ',
    DayOfTheYear(D2));
  WriteLn(IsLeapYear(2024), ' ', IsLeapYear(2100), ' ',
    DaysInMonth(EncodeDate(2024, 2, 1)));
  WriteLn(CompareDate(D, D2), ' ', SameDate(D, D + 0.9), ' ',
    IsInLeapYear(D));
  WriteLn(HoursBetween(D + 0.5, D), ' ',
    MinutesBetween(D + 1, D));
end.
