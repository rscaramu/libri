{ Validazione12 - Manuale completo di Free Pascal e Lazarus }
program Validazione12;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  EValidazione = class(Exception);
  EEtaNonValida = class(EValidazione);
  ENomeVuoto = class(EValidazione);

procedure ValidaPersona(const Nome: String; Eta: Integer);
begin
  if Trim(Nome) = '' then
    raise ENomeVuoto.Create('Il nome e'' obbligatorio');
  if (Eta < 0) or (Eta > 130) then
    raise EEtaNonValida.CreateFmt('Eta'' %d non valida',
                                  [Eta]);
end;

procedure Prova(const Nome: String; Eta: Integer);
begin
  try
    ValidaPersona(Nome, Eta);
    WriteLn('OK: ', Nome, ', ', Eta);
  except
    on E: EValidazione do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end;

begin
  Prova('Ada', 36);
  Prova('', 36);
  Prova('Alan', 150);
end.
