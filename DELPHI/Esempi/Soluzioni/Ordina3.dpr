program Ordina3;

{$APPTYPE CONSOLE}

procedure Scambia(var X, Y: Integer);
var
  T: Integer;
begin
  T := X; X := Y; Y := T;
end;

procedure Ordina3(var A, B, C: Integer);
begin
  if A > B then Scambia(A, B);
  if B > C then Scambia(B, C);
  if A > B then Scambia(A, B);
end;

const
  P: array[0..5, 0..2] of Integer =
    ((1, 2, 3), (1, 3, 2), (2, 1, 3), (2, 3, 1), (3, 1, 2),
     (3, 2, 1));
var
  I, A, B, C: Integer;
begin
  for I := 0 to 5 do
  begin
    A := P[I, 0]; B := P[I, 1]; C := P[I, 2];
    Ordina3(A, B, C);
    Write(A, B, C, ' ');
  end;
  WriteLn;
end.
