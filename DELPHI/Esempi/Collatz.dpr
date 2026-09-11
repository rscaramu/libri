program Collatz;

{$APPTYPE CONSOLE}

var
  N, Passi: Integer;
begin
  N := 27;
  Passi := 0;
  while N <> 1 do
  begin
    if N mod 2 = 0 then
      N := N div 2
    else
      N := 3 * N + 1;
    Inc(Passi);
  end;
  WriteLn('Passi: ', Passi);
end.
