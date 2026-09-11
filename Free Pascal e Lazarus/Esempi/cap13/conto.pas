{ Conto - Manuale completo di Free Pascal e Lazarus }
program Conto;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  ESaldoInsufficiente = class(Exception);

  TConto = class
  private
    FTitolare: String;
    FSaldo: Currency;
  public
    constructor Create(const ATitolare: String);
    procedure Deposita(Importo: Currency);
    procedure Preleva(Importo: Currency);
    property Titolare: String read FTitolare;
    property Saldo: Currency read FSaldo;
  end;

constructor TConto.Create(const ATitolare: String);
begin
  inherited Create;
  FTitolare := ATitolare;
end;

procedure TConto.Deposita(Importo: Currency);
begin
  if Importo <= 0 then
    raise EArgumentException.Create('Importo non valido');
  FSaldo := FSaldo + Importo;
end;

procedure TConto.Preleva(Importo: Currency);
begin
  if Importo > FSaldo then
    raise ESaldoInsufficiente.CreateFmt(
      'Saldo %.2f insufficiente per %.2f', [FSaldo, Importo]);
  FSaldo := FSaldo - Importo;
end;

var
  C: TConto;
begin
  C := TConto.Create('Mario');
  try
    C.Deposita(100);
    C.Preleva(30);
    WriteLn(C.Titolare, ': ', C.Saldo:0:2);
    try
      C.Preleva(500);
    except
      on E: ESaldoInsufficiente do
        WriteLn(E.Message);
    end;
  finally
    C.Free;
  end;
end.
