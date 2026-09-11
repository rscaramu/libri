program Formati;

{$APPTYPE CONSOLE}

uses
  SysUtils, DateUtils;

var
  D: TDateTime;
begin
  D := EncodeDate(2026, 3, 5) + EncodeTime(9, 7, 3, 250);
  WriteLn(FormatDateTime('dd"/"mm"/"yyyy', D));
  WriteLn(FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', D));
  WriteLn(FormatDateTime('d"/"m"/"yy h:n:s.zzz', D));
  WriteLn(FormatDateTime('hh:nn am/pm', D));
  WriteLn(FormatDateTime('"giorno" d "del mese" m', D));
  WriteLn(DateToISO8601(D, False));
end.
