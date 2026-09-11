{ LogSicuro - Manuale completo di Free Pascal e Lazarus }
program LogSicuro;
{$mode objfpc}{$H+}
uses
  SysUtils;

procedure Registra(const NomeFile, Msg: String);
var
  F: TextFile;
begin
  AssignFile(F, NomeFile);
  if FileExists(NomeFile) then
    Append(F)
  else
    Rewrite(F);
  try
    WriteLn(F, FormatDateTime('yyyy-mm-dd hh:nn', Now),
            ' ', Msg);
  finally
    CloseFile(F);
  end;
end;

procedure RegistraSicuro(const NomeFile, Msg: String);
begin
  try
    Registra(NomeFile, Msg);
    WriteLn('Registrato su ', NomeFile);
  except
    on E: EInOutError do
      WriteLn('Impossibile scrivere il log (',
              E.ErrorCode, '): ', E.Message);
  end;
end;

begin
  RegistraSicuro('app.log', 'avvio');
  RegistraSicuro('/cartella/inesistente/app.log', 'avvio');
end.
