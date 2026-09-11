{ Triangoli - Manuale completo di Free Pascal e Lazarus }
program Triangoli;
{$mode objfpc}{$H+}
const
  H = 5;
var
  R, C: Integer;
begin
  for R := 1 to H do
  begin
    for C := 1 to R do
      Write('*');
    WriteLn;
  end;
  WriteLn;
  for R := 1 to H do
  begin
    for C := 1 to H - R do
      Write(' ');
    for C := 1 to 2 * R - 1 do
      Write('*');
    WriteLn;
  end;
end.
