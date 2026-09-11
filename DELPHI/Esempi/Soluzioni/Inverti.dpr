program Inverti;

{$APPTYPE CONSOLE}

function Inverti(const A: array of Integer): TArray<Integer>;
var
  I: Integer;
begin
  SetLength(Result, Length(A));
  for I := 0 to High(A) do
    Result[High(A) - I] := A[I];
end;

var
  V: TArray<Integer>;
  X: Integer;
begin
  V := [1, 2, 3, 4];
  for X in Inverti(V) do
    Write(X, ' ');
  WriteLn;
  WriteLn(V[0]);
end.
