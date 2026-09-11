{ Sollevare - Manuale completo di Free Pascal e Lazarus }
program Sollevare;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  ESaldoInsufficiente = class(Exception);
  EContoChiuso = class(Exception)
    Codice: Integer;
    constructor Create(ACodice: Integer);
  end;

constructor EContoChiuso.Create(ACodice: Integer);
begin
  inherited CreateFmt('Il conto %d e'' chiuso', [ACodice]);
  Codice := ACodice;
end;

procedure Preleva(var Saldo: Currency; Importo: Currency);
begin
  if Importo <= 0 then
    raise EArgumentException.Create('Importo non positivo');
  if Importo > Saldo then
    raise ESaldoInsufficiente.CreateFmt(
      'Servono %.2f, disponibili %.2f', [Importo, Saldo]);
  Saldo := Saldo - Importo;
end;

var
  S: Currency;
begin
  S := 100;
  try
    Preleva(S, 30);
    WriteLn('Saldo: ', S:0:2);
    Preleva(S, 100);
  except
    on E: ESaldoInsufficiente do
      WriteLn('Rifiutato: ', E.Message);
  end;
  try
    Preleva(S, -5);
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
  try
    raise EContoChiuso.Create(42);
  except
    on E: EContoChiuso do
      WriteLn(E.Message, ' (codice ', E.Codice, ')');
  end;
end.
