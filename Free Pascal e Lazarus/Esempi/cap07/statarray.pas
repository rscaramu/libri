{ StatArray - Manuale completo di Free Pascal e Lazarus }
program StatArray;
{$mode objfpc}{$H+}
var
  A: array of Integer;
  I, Mn, Mx, Somma: Integer;
begin
  RandSeed := 2026;
  SetLength(A, 10);
  for I := 0 to High(A) do
  begin
    A[I] := Random(100) + 1;
    Write(A[I], ' ');
  end;
  WriteLn;
  Mn := A[0];
  Mx := A[0];
  Somma := 0;
  for I := 0 to High(A) do
  begin
    if A[I] < Mn then Mn := A[I];
    if A[I] > Mx then Mx := A[I];
    Somma := Somma + A[I];
  end;
  WriteLn('Min ', Mn, ' Max ', Mx, ' Media ',
          Somma / Length(A):0:1);
end.
