program PrimaClasse;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TConto = class
  private
    FIntestatario: string;
    FSaldo: Currency;
  public
    constructor Create(const AIntestatario: string);
    procedure Versa(Importo: Currency);
    function Preleva(Importo: Currency): Boolean;
    function Descrizione: string;
    property Intestatario: string read FIntestatario;
    property Saldo: Currency read FSaldo;
  end;

constructor TConto.Create(const AIntestatario: string);
begin
  inherited Create;
  FIntestatario := AIntestatario;
  FSaldo := 0;
end;

procedure TConto.Versa(Importo: Currency);
begin
  if Importo > 0 then
    FSaldo := FSaldo + Importo;
end;

function TConto.Preleva(Importo: Currency): Boolean;
begin
  Result := (Importo > 0) and (Importo <= FSaldo);
  if Result then
    FSaldo := FSaldo - Importo;
end;

function TConto.Descrizione: string;
begin
  Result := Format('%s: %.2f', [FIntestatario, FSaldo]);
end;

var
  C: TConto;
begin
  C := TConto.Create('Anna Bianchi');
  try
    C.Versa(1000);
    WriteLn(C.Preleva(300), ' ', C.Preleva(5000));
    WriteLn(C.Descrizione);
    WriteLn(C.Saldo:0:2);
  finally
    C.Free;
  end;
end.
