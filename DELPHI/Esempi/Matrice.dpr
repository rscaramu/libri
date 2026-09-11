program Matrice;

{$APPTYPE CONSOLE}

var
  M: array[1..3, 1..3] of Integer;
  R, C: Integer;
begin
  for R := 1 to 3 do
    for C := 1 to 3 do
      if R = C then
        M[R, C] := 1
      else
        M[R, C] := 0;
  for R := 1 to 3 do
  begin
    for C := 1 to 3 do
      Write(M[R, C], ' ');
    WriteLn;
  end;
  WriteLn(M[2][2], ' ', Length(M), ' ', Length(M[1]));
end.
