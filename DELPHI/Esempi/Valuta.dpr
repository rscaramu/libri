program Valuta;

{$APPTYPE CONSOLE}

begin
  WriteLn(17 div 5 * 5 + 17 mod 5);
  WriteLn(2 + 3 * 4 - 1);
  WriteLn((2 + 3) * (4 - 1));
  WriteLn(10 / 4:0:1);
  WriteLn(not True or False);
  WriteLn($F0 shr 4);
end.
