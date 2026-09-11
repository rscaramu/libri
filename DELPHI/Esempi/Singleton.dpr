program Singleton;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TConfigurazione = class
  private
    class var FIstanza: TConfigurazione;
    var FValori: string;
  public
    class function Istanza: TConfigurazione;
    class procedure Libera;
    property Valori: string read FValori write FValori;
  end;

class function TConfigurazione.Istanza: TConfigurazione;
begin
  if FIstanza = nil then
    FIstanza := TConfigurazione.Create;
  Result := FIstanza;
end;

class procedure TConfigurazione.Libera;
begin
  FreeAndNil(FIstanza);
end;

begin
  TConfigurazione.Istanza.Valori := 'a=1';
  WriteLn(TConfigurazione.Istanza.Valori);
  WriteLn(TConfigurazione.Istanza = TConfigurazione.Istanza);
  TConfigurazione.Libera;
end.
