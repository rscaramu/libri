{ Account - Manuale completo di Free Pascal e Lazarus }
program Account;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TAccount = class
  protected
    FSaldo: Currency;
  public
    constructor Create(ASaldo: Currency);
    procedure ChiusuraMese; virtual; abstract;
    property Saldo: Currency read FSaldo;
  end;

  TAccountRisparmio = class(TAccount)
    procedure ChiusuraMese; override;
  end;

  TAccountCorrente = class(TAccount)
    procedure ChiusuraMese; override;
  end;

constructor TAccount.Create(ASaldo: Currency);
begin
  FSaldo := ASaldo;
end;

procedure TAccountRisparmio.ChiusuraMese;
begin
  FSaldo := FSaldo + FSaldo * 0.02;   { interessi }
end;

procedure TAccountCorrente.ChiusuraMese;
begin
  if FSaldo < 0 then
    FSaldo := FSaldo - 5;             { spese sul fido }
end;

var
  A: array[0..1] of TAccount;
  I: Integer;
begin
  A[0] := TAccountRisparmio.Create(1000);
  A[1] := TAccountCorrente.Create(-100);
  for I := 0 to 1 do
  begin
    A[I].ChiusuraMese;
    WriteLn(A[I].ClassName, ': ', A[I].Saldo:0:2);
    A[I].Free;
  end;
end.
