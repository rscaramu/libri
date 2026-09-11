{ Divisioni - Manuale completo di Free Pascal e Lazarus }
program Divisioni;
{$mode objfpc}{$H+}
begin
  WriteLn('17 / 5   = ', 17 / 5:0:2);
  WriteLn('17 div 5 = ', 17 div 5);
  WriteLn('17 mod 5 = ', 17 mod 5);
  WriteLn('-17 div 5 = ', -17 div 5);
  WriteLn('-17 mod 5 = ', -17 mod 5);
  WriteLn('17 mod -5 = ', 17 mod -5);
end.
