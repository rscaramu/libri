{ PrimaEccezione - Manuale completo di Free Pascal e Lazarus }
program PrimaEccezione;
{$mode objfpc}{$H+}
uses
  SysUtils;
var
  N: Integer;
begin
  try
    N := StrToInt('42');
    WriteLn('Convertito: ', N);
    N := StrToInt('quarantadue');
    WriteLn('mai stampato');
  except
    on E: EConvertError do
      WriteLn('Conversione fallita: ', E.Message);
  end;
  WriteLn('Il programma continua');
end.
