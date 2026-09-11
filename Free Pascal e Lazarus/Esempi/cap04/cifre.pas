{ Cifre - Manuale completo di Free Pascal e Lazarus }
program Cifre;
{$mode objfpc}{$H+}
var
  N, C, D, U: Integer;
begin
  N := 738;
  C := N div 100;
  D := (N div 10) mod 10;
  U := N mod 10;
  WriteLn(N, ' = ', C, ' centinaia, ', D, ' decine, ',
          U, ' unita');
end.
