{ Parametri - Manuale completo di Free Pascal e Lazarus }
program Parametri;
{$mode objfpc}{$H+}
var
  I: Integer;
begin
  WriteLn('Parametri: ', ParamCount);
  for I := 1 to ParamCount do
    WriteLn(I, ': ', ParamStr(I));
  if ParamCount = 0 then
    WriteLn('Uso: parametri <file> [opzioni]');
end.
