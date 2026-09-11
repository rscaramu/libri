{ ProvaImpostazioni - Manuale completo di Free Pascal e Lazarus }
program ProvaImpostazioni;
{$mode objfpc}{$H+}
uses
  SysUtils, Impostazioni;
var
  I: TImpostazioni;
begin
  I := TImpostazioni.Create;
  try
    I.Cancella;             { partiamo da zero }
    I.Carica;
    WriteLn('Prima: ', I.Lingua, ' ', I.Tema);
    I.Tema := 'scuro';
    I.UltimoFile := 'prova.txt';
    I.Salva;
  finally
    I.Free;
  end;
  I := TImpostazioni.Create;
  try
    I.Carica;
    WriteLn('Dopo: ', I.Lingua, ' ', I.Tema, ' ',
            I.UltimoFile);
  finally
    I.Free;
  end;
end.
