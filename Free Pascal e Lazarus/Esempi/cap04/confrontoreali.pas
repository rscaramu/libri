{ ConfrontoReali - Manuale completo di Free Pascal e Lazarus }
program ConfrontoReali;
{$mode objfpc}{$H+}
uses
  Math;
var
  X, Y, A, B: Double;
begin
  X := 0.1;
  Y := 0.2;
  A := X + Y;
  B := 0.3;
  WriteLn('A = B         : ', A = B);
  WriteLn('SameValue     : ', SameValue(A, B));
  WriteLn('Abs(A-B)<1E-9 : ', Abs(A - B) < 1E-9);
  WriteLn('CompareValue  : ', CompareValue(A, B));
  WriteLn('con Epsilon   : ', CompareValue(A, B, 1E-9));
end.
