program Cifre;

{$APPTYPE CONSOLE}

var
  N, C, D, U: Integer;
begin
  N := 472;
  C := N div 100;
  D := (N div 10) mod 10;
  U := N mod 10;
  WriteLn(C, ' ', D, ' ', U);
  WriteLn(C * 100 + D * 10 + U);
end.
