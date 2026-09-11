program TriangoloAsterischi;

{$APPTYPE CONSOLE}

var
  R, C: Integer;
begin
  for R := 1 to 5 do
  begin
    for C := 1 to R do
      Write('*');
    WriteLn;
  end;
end.
