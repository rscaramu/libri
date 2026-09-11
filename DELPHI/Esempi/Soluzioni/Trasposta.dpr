program Trasposta;

{$APPTYPE CONSOLE}

var
  M: array[1..4, 1..4] of Integer;
  R, C: Integer;
begin
  for R := 1 to 4 do
    for C := 1 to 4 do
      M[R, C] := (R - 1) * 4 + C;
  for R := 1 to 4 do
  begin
    for C := 1 to 4 do
      Write(M[C, R]:3);
    WriteLn;
  end;
end.
