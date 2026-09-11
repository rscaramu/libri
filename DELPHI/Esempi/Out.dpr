program Out;

{$APPTYPE CONSOLE}

procedure DivMod(Dividendo, Divisore: Integer;
  out Quoziente, Resto: Integer);
begin
  Quoziente := Dividendo div Divisore;
  Resto := Dividendo mod Divisore;
end;

var
  Q, R: Integer;
begin
  DivMod(17, 5, Q, R);
  WriteLn(Q, ' resto ', R);
end.
