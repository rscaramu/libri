program Dinamici;

{$APPTYPE CONSOLE}

var
  A, B: array of Integer;
  I: Integer;
begin
  WriteLn(Length(A));
  SetLength(A, 5);
  for I := 0 to High(A) do
    A[I] := I * I;
  WriteLn(Length(A), ' ', A[4]);
  SetLength(A, 7);
  WriteLn(A[4], ' ', A[6]);
  B := A;
  B[0] := 100;
  WriteLn(A[0]);
  B := Copy(A);
  B[0] := 200;
  WriteLn(A[0], ' ', B[0]);
  SetLength(A, 0);
  WriteLn(Length(A), ' ', A = nil);
end.
