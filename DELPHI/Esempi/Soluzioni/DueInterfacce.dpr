program DueInterfacce;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  IDepositabile = interface
    ['{5A1E6B2C-3D4F-4A5B-8C6D-7E8F9A0B1C2D}']
    procedure Deposita(Importo: Currency);
  end;
  IPrelevabile = interface
    ['{6B2F7C3D-4E5A-4B6C-9D7E-8F9A0B1C2D3E}']
    procedure Preleva(Importo: Currency);
    function Saldo: Currency;
  end;
  TContoCorrente = class(TInterfacedObject, IDepositabile,
    IPrelevabile)
  private
    FSaldo: Currency;
  public
    procedure Deposita(Importo: Currency);
    procedure Preleva(Importo: Currency);
    function Saldo: Currency;
  end;

procedure TContoCorrente.Deposita(Importo: Currency);
begin
  FSaldo := FSaldo + Importo;
end;

procedure TContoCorrente.Preleva(Importo: Currency);
begin
  FSaldo := FSaldo - Importo;
end;

function TContoCorrente.Saldo: Currency;
begin
  Result := FSaldo;
end;

procedure Versa(const D: IDepositabile);
begin
  D.Deposita(100);
end;

var
  D: IDepositabile;
  P: IPrelevabile;
begin
  D := TContoCorrente.Create;
  Versa(D);
  if Supports(D, IPrelevabile, P) then
  begin
    P.Preleva(30);
    WriteLn(P.Saldo:0:2);
  end;
end.
