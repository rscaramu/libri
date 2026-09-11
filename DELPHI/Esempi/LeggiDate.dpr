program LeggiDate;

{$APPTYPE CONSOLE}

uses
  SysUtils, DateUtils;

var
  FS: TFormatSettings;
  D: TDateTime;
begin
  FS := FormatSettings;
  FS.DateSeparator := '/';
  FS.ShortDateFormat := 'dd/mm/yyyy';
  FS.TimeSeparator := ':';
  D := StrToDate('15/03/2026', FS);
  WriteLn(FormatDateTime('yyyy-mm-dd', D));
  WriteLn(TryStrToDate('31/02/2026', D, FS));
  WriteLn(TryStrToDate('abc', D, FS));
  D := StrToDateTime('01/12/2026 18:45', FS);
  WriteLn(FormatDateTime('yyyy-mm-dd hh:nn', D));
  D := ISO8601ToDate('2026-07-04T10:00:00Z', False);
  WriteLn(FormatDateTime('dd"/"mm"/"yyyy hh:nn', D));
  FS.ShortDateFormat := 'yyyy-mm-dd';
  FS.DateSeparator := '-';
  WriteLn(TryStrToDate('2026-07-04', D, FS));
end.
