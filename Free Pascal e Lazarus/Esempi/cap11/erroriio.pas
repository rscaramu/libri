{ ErroriIO - Manuale completo di Free Pascal e Lazarus }
program ErroriIO;
{$mode objfpc}{$H+}
var
  F: TextFile;
  Codice: Integer;
begin
  AssignFile(F, 'non_esiste.txt');
  {$I-}
  Reset(F);
  {$I+}
  Codice := IOResult;
  if Codice <> 0 then
    WriteLn('Errore di apertura, codice ', Codice)
  else
  begin
    WriteLn('Aperto');
    CloseFile(F);
  end;
end.
