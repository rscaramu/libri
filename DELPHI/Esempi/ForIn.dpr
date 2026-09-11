program ForIn;

{$APPTYPE CONSOLE}

var
  Numeri: array[0..4] of Integer;
  N, Somma: Integer;
  C: Char;
begin
  Numeri[0] := 3; Numeri[1] := 1; Numeri[2] := 4;
  Numeri[3] := 1; Numeri[4] := 5;
  Somma := 0;
  for N in Numeri do
    Somma := Somma + N;
  WriteLn(Somma);
  for C in 'ciao' do
    Write(UpCase(C));
  WriteLn;
end.
