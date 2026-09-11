{ BubbleSort - Manuale completo di Free Pascal e Lazarus }
program BubbleSort;
{$mode objfpc}{$H+}
type
  TInteri = array of Integer;

procedure Ordina(var A: TInteri);
var
  I, J, T: Integer;
begin
  for I := High(A) downto 1 do
    for J := 0 to I - 1 do
      if A[J] > A[J + 1] then
      begin
        T := A[J];
        A[J] := A[J + 1];
        A[J + 1] := T;
      end;
end;

procedure Stampa(const A: TInteri);
var
  V: Integer;
begin
  for V in A do
    Write(V, ' ');
  WriteLn;
end;

var
  A: TInteri;
begin
  A := [5, 2, 9, 1, 7];
  Stampa(A);
  Ordina(A);
  Stampa(A);
end.
