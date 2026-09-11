{ CicliCondizionali - Manuale completo di Free Pascal e Lazarus }
program CicliCondizionali;
{$mode objfpc}{$H+}
var
  N, Passi: Integer;
begin
  { congettura di Collatz }
  N := 27;
  Passi := 0;
  while N <> 1 do
  begin
    if Odd(N) then
      N := 3 * N + 1
    else
      N := N div 2;
    Inc(Passi);
  end;
  WriteLn('27 raggiunge 1 in ', Passi, ' passi');

  { cifre di un numero, dalla meno significativa }
  N := 2026;
  repeat
    Write(N mod 10, ' ');
    N := N div 10;
  until N = 0;
  WriteLn;
end.
