program Divisioni;

{$APPTYPE CONSOLE}

begin
  WriteLn(7 / 2:0:2);
  WriteLn(7 div 2);
  WriteLn(7 mod 2);
  WriteLn(-7 div 2, ' ', -7 mod 2);
  WriteLn(7 div -2, ' ', 7 mod -2);
end.
