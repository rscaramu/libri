program Inventario;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Collections;

type
  TArticolo = class
    Codice: string;
    Prezzo: Currency;
    Quantita: Integer;
  end;
  TInventario = class
  private
    FArticoli: TObjectDictionary<string, TArticolo>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Definisci(const Codice: string;
      Prezzo: Currency);
    procedure Carica(const Codice: string;
      Quantita: Integer);
    procedure Scarica(const Codice: string;
      Quantita: Integer);
    function Valore: Currency;
  end;

constructor TInventario.Create;
begin
  inherited;
  FArticoli := TObjectDictionary<string, TArticolo>.Create(
    [doOwnsValues]);
end;

destructor TInventario.Destroy;
begin
  FArticoli.Free;
  inherited;
end;

procedure TInventario.Definisci(const Codice: string;
  Prezzo: Currency);
var
  A: TArticolo;
begin
  A := TArticolo.Create;
  A.Codice := Codice;
  A.Prezzo := Prezzo;
  FArticoli.Add(Codice, A);
end;

procedure TInventario.Carica(const Codice: string;
  Quantita: Integer);
begin
  FArticoli[Codice].Quantita := FArticoli[Codice].Quantita +
    Quantita;
end;

procedure TInventario.Scarica(const Codice: string;
  Quantita: Integer);
begin
  if FArticoli[Codice].Quantita < Quantita then
    raise EInvalidOpException.Create('scorte insufficienti');
  FArticoli[Codice].Quantita := FArticoli[Codice].Quantita -
    Quantita;
end;

function TInventario.Valore: Currency;
var
  A: TArticolo;
begin
  Result := 0;
  for A in FArticoli.Values do
    Result := Result + A.Prezzo * A.Quantita;
end;

var
  I: TInventario;
begin
  I := TInventario.Create;
  try
    I.Definisci('A', 2);
    I.Definisci('B', 5);
    I.Carica('A', 10);
    I.Carica('B', 3);
    I.Scarica('A', 4);
    WriteLn(I.Valore:0:2);
    try
      I.Scarica('B', 10);
    except
      on E: EInvalidOpException do
        WriteLn(E.Message);
    end;
  finally
    I.Free;
  end;
end.
