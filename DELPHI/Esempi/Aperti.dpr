program Aperti;

{$APPTYPE CONSOLE}

function Somma(const A: array of Integer): Integer;
var
  X: Integer;
begin
  Result := 0;
  for X in A do
    Result := Result + X;
end;

var
  Fissi: array[1..3] of Integer;
  Dinamici: array of Integer;
begin
  Fissi[1] := 1; Fissi[2] := 2; Fissi[3] := 3;
  Dinamici := [10, 20];
  WriteLn(Somma(Fissi));
  WriteLn(Somma(Dinamici));
  WriteLn(Somma([5, 5, 5, 5]));
  WriteLn(Somma([]));
end.
