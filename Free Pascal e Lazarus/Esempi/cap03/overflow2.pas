{ Overflow2 - Manuale completo di Free Pascal e Lazarus }
program Overflow2;
{$mode objfpc}{$H+}
var
  A: Integer;
  B: Int64;
begin
  A := 100000 * 100000;
  B := Int64(100000) * 100000;
  WriteLn('Integer: ', A);
  WriteLn('Int64  : ', B);
end.
