{ Interfacce1 - Manuale completo di Free Pascal e Lazarus }
program Interfacce1;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  IStampabile = interface
    ['{7F1A2B3C-0001-4000-8000-000000000001}']
    function Testo: String;
  end;

  ISalvabile = interface
    ['{7F1A2B3C-0002-4000-8000-000000000002}']
    procedure Salva(const Percorso: String);
  end;

  TFattura = class(TInterfacedObject, IStampabile, ISalvabile)
  private
    FNumero: Integer;
    FImporto: Currency;
  public
    constructor Create(ANumero: Integer; AImporto: Currency);
    destructor Destroy; override;
    function Testo: String;
    procedure Salva(const Percorso: String);
  end;

constructor TFattura.Create(ANumero: Integer;
                            AImporto: Currency);
begin
  FNumero := ANumero;
  FImporto := AImporto;
end;

destructor TFattura.Destroy;
begin
  WriteLn('  fattura ', FNumero, ' distrutta');
  inherited;
end;

function TFattura.Testo: String;
begin
  Result := Format('Fattura n. %d: %.2f euro',
                   [FNumero, FImporto]);
end;

procedure TFattura.Salva(const Percorso: String);
begin
  WriteLn('  salvo "', Testo, '" in ', Percorso);
end;

procedure Stampa(Doc: IStampabile);
begin
  WriteLn(Doc.Testo);
end;

var
  S: IStampabile;
  V: ISalvabile;
begin
  S := TFattura.Create(1, 120.50);
  Stampa(S);
  if Supports(S, ISalvabile, V) then
    V.Salva('fatture/1.txt');
  WriteLn('RefCount: ', (S as TInterfacedObject).RefCount);
  V := nil;
  WriteLn('RefCount: ', (S as TInterfacedObject).RefCount);
  S := nil;                { ultimo riferimento: distruzione }
  WriteLn('fine');
end.
