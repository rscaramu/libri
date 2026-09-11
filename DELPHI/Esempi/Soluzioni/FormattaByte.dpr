program FormattaByte;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function FormattaByte(N: Int64): string;
const
  Unita: array[0..4] of string =
    ('B', 'KB', 'MB', 'GB', 'TB');
var
  V: Double;
  I: Integer;
  FS: TFormatSettings;
begin
  FS := FormatSettings;
  FS.DecimalSeparator := ',';
  V := N;
  I := 0;
  while (V >= 1024) and (I < High(Unita)) do
  begin
    V := V / 1024;
    Inc(I);
  end;
  if I = 0 then
    Result := Format('%d B', [N])
  else
    Result := FormatFloat('0.0', V, FS) + ' ' + Unita[I];
end;

begin
  WriteLn(FormattaByte(512));
  WriteLn(FormattaByte(1536));
  WriteLn(FormattaByte(24536064));
  WriteLn(FormattaByte(1288490189));
end.
