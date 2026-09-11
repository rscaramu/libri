program ImportoItaliano;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function LeggiImporto(const S: string): Currency;
var
  FS: TFormatSettings;
begin
  FS := FormatSettings;
  FS.DecimalSeparator := ',';
  FS.ThousandSeparator := '.';
  Result := StrToCurr(
    StringReplace(S, '.', '', [rfReplaceAll]), FS);
end;

begin
  WriteLn(LeggiImporto('1.234,56'):0:2);
  WriteLn(LeggiImporto('7,5'):0:2);
end.
