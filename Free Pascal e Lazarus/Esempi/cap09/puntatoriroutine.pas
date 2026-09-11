{ PuntatoriRoutine - Manuale completo di Free Pascal e Lazarus }
program PuntatoriRoutine;
{$mode objfpc}{$H+}
type
  TOperazione = function(A, B: Integer): Integer;
  TAzione = procedure(V: Integer);

function Somma(A, B: Integer): Integer;
begin
  Result := A + B;
end;

function Prodotto(A, B: Integer): Integer;
begin
  Result := A * B;
end;

procedure StampaQuadrato(V: Integer);
begin
  WriteLn(V, '^2 = ', V * V);
end;

function Riduci(const A: array of Integer; Op: TOperazione;
                Iniziale: Integer): Integer;
var
  I: Integer;
begin
  Result := Iniziale;
  for I := 0 to High(A) do
    Result := Op(Result, A[I]);
end;

procedure PerOgni(const A: array of Integer; Az: TAzione);
var
  I: Integer;
begin
  for I := 0 to High(A) do
    Az(A[I]);
end;

begin
  WriteLn('Somma:    ', Riduci([1, 2, 3, 4], @Somma, 0));
  WriteLn('Prodotto: ', Riduci([1, 2, 3, 4], @Prodotto, 1));
  PerOgni([2, 3], @StampaQuadrato);
end.
