{ Cache - Manuale completo di Free Pascal e Lazarus }
program Cache;
{$mode objfpc}{$H+}
uses
  SysUtils, Generics.Collections;
type
  generic TCache<K, V> = class
  public type
    TCalcolo = function(const Chiave: K): V;
    TMappa = specialize TDictionary<K, V>;
  private
    FDati: TMappa;
    FCalcolo: TCalcolo;
    FCalcolati: Integer;
  public
    constructor Create(ACalcolo: TCalcolo);
    destructor Destroy; override;
    function Ottieni(const Chiave: K): V;
    property Calcolati: Integer read FCalcolati;
  end;
  TCacheQuadrati = specialize TCache<Integer, Int64>;

constructor TCache.Create(ACalcolo: TCalcolo);
begin
  FDati := TMappa.Create;
  FCalcolo := ACalcolo;
end;

destructor TCache.Destroy;
begin
  FDati.Free;
  inherited;
end;

function TCache.Ottieni(const Chiave: K): V;
begin
  if not FDati.TryGetValue(Chiave, Result) then
  begin
    Result := FCalcolo(Chiave);
    FDati.Add(Chiave, Result);
    Inc(FCalcolati);
  end;
end;

function Quadrato(const N: Integer): Int64;
begin
  Result := Int64(N) * N;
end;

var
  C: TCacheQuadrati;
begin
  C := TCacheQuadrati.Create(@Quadrato);
  try
    WriteLn(C.Ottieni(12), ' ', C.Ottieni(12), ' ',
            C.Ottieni(5));
    WriteLn('Calcoli effettivi: ', C.Calcolati);
  finally
    C.Free;
  end;
end.
