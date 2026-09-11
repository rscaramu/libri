{ TryFinally - Manuale completo di Free Pascal e Lazarus }
program TryFinally;
{$mode objfpc}{$H+}
uses
  SysUtils;

procedure Elabora(const Nome: String; Fallisci: Boolean);
var
  F: TextFile;
begin
  AssignFile(F, Nome);
  Rewrite(F);
  try
    WriteLn(F, 'riga 1');
    if Fallisci then
      raise Exception.Create('errore simulato');
    WriteLn(F, 'riga 2');
  finally
    CloseFile(F);
    WriteLn('  file chiuso');
  end;
  WriteLn('  elaborazione completata');
end;

begin
  Elabora('ok.txt', False);
  try
    Elabora('ko.txt', True);
  except
    on E: Exception do
      WriteLn('Catturata: ', E.Message);
  end;
end.
