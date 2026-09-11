{ Mappa - Manuale completo di Free Pascal e Lazarus }
program Mappa;
{$mode objfpc}{$H+}
type
  TReali = array of Double;
  TFunzione = function(X: Double): Double;

function Doppio(X: Double): Double;
begin
  Result := 2 * X;
end;

function Quadrato(X: Double): Double;
begin
  Result := X * X;
end;

procedure MappaSulPosto(var A: TReali; F: TFunzione);
var
  I: Integer;
begin
  for I := 0 to High(A) do
    A[I] := F(A[I]);
end;

procedure Stampa(const A: TReali);
var
  X: Double;
begin
  for X in A do
    Write(X:0:1, ' ');
  WriteLn;
end;

var
  A: TReali;
begin
  A := [1, 2, 3];
  MappaSulPosto(A, @Doppio);
  Stampa(A);
  MappaSulPosto(A, @Quadrato);
  Stampa(A);
end.
