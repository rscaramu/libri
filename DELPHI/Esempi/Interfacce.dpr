program Interfacce;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  IStampabile = interface
    ['{4D9B0C5E-1A2F-4C8B-9E3D-7F6A5B4C3D2E}']
    function TestoStampa: string;
  end;

  IEsportabile = interface
    ['{A1B2C3D4-E5F6-4A7B-8C9D-0E1F2A3B4C5D}']
    function Esporta: string;
  end;

  TFattura = class(TInterfacedObject, IStampabile,
    IEsportabile)
  private
    FNumero: Integer;
  public
    constructor Create(ANumero: Integer);
    function TestoStampa: string;
    function Esporta: string;
  end;

  TNota = class(TInterfacedObject, IStampabile)
    function TestoStampa: string;
  end;

constructor TFattura.Create(ANumero: Integer);
begin
  inherited Create;
  FNumero := ANumero;
end;

function TFattura.TestoStampa: string;
begin
  Result := 'FATTURA n. ' + IntToStr(FNumero);
end;

function TFattura.Esporta: string;
begin
  Result := '{"fattura":' + IntToStr(FNumero) + '}';
end;

function TNota.TestoStampa: string;
begin
  Result := 'NOTA';
end;

procedure Stampa(const S: IStampabile);
begin
  WriteLn(S.TestoStampa);
end;

var
  Documenti: array of IStampabile;
  D: IStampabile;
  E: IEsportabile;
begin
  Documenti := [TFattura.Create(7), TNota.Create];
  for D in Documenti do
    Stampa(D);
  if Supports(Documenti[0], IEsportabile, E) then
    WriteLn(E.Esporta);
  WriteLn(Supports(Documenti[1], IEsportabile));
end.
