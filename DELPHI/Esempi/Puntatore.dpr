program Puntatore;

{$APPTYPE CONSOLE}

var
  N: Integer;
  P: ^Integer;
begin
  N := 42;
  P := @N;
  WriteLn(P^);
  P^ := 7;
  WriteLn(N);
end.
