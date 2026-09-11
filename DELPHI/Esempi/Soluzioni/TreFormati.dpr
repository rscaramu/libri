program TreFormati;

{$APPTYPE CONSOLE}

uses
  SysUtils, DateUtils;

function Riconosci(const S: string;
  out D: TDateTime): Boolean;
var
  FS: TFormatSettings;
  I: Integer;
const
  Formati: array[0..2] of string =
    ('dd/mm/yyyy', 'yyyy-mm-dd', 'dd.mm.yyyy');
  Separatori: array[0..2] of Char = ('/', '-', '.');
begin
  FS := FormatSettings;
  for I := 0 to 2 do
  begin
    FS.ShortDateFormat := Formati[I];
    FS.DateSeparator := Separatori[I];
    if TryStrToDate(S, D, FS) then
      Exit(True);
  end;
  Result := False;
end;

var
  D: TDateTime;
  S: string;
begin
  for S in ['15/03/2026', '2026-03-15', '15.03.2026', 'x'] do
    if Riconosci(S, D) then
      WriteLn(DateToISO8601(D, False))
    else
      WriteLn(S, ': non riconosciuta');
end.
