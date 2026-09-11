{ Tabella - Manuale completo di Free Pascal e Lazarus }
program Tabella;
{$mode objfpc}{$H+}
var
  I: Integer;
begin
  WriteLn('N':4, 'Quadrato':10, 'Radice':10);
  for I := 1 to 5 do
    WriteLn(I:4, I * I:10, Sqrt(I):10:3);
end.
