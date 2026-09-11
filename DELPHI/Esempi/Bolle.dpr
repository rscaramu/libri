program Bolle;

{$APPTYPE CONSOLE}

procedure Ordina(var A: array of Integer);
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

var
  V: array of Integer;
  X: Integer;
begin
  V := [5, 3, 8, 1, 9, 2];
  Ordina(V);
  for X in V do
    Write(X, ' ');
  WriteLn;
end.
