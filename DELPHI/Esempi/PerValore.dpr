program PerValore;

{$APPTYPE CONSOLE}

procedure Raddoppia(N: Integer);
begin
  N := N * 2;
  WriteLn('dentro: ', N);
end;

var
  X: Integer;
begin
  X := 21;
  Raddoppia(X);
  WriteLn('fuori: ', X);
end.
