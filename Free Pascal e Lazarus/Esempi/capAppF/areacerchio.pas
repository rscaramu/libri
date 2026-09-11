{ AreaCerchio - Manuale completo di Free Pascal e Lazarus }
program AreaCerchio;
{$mode objfpc}{$H+}
uses
  Math;
var
  R, A1, A2: Double;
begin
  R := 2.5;
  A1 := Pi * Sqr(R);
  A2 := Pi * 2.5 * 2.5;
  WriteLn(A1:0:3, ' ', SameValue(A1, A2));
end.
