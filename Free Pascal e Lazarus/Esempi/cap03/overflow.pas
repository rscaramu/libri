{ Overflow - Manuale completo di Free Pascal e Lazarus }
program Overflow;
{$mode objfpc}{$H+}
var
  N: Integer;
  B: Byte;
begin
  N := High(Integer);
  N := N + 1;
  WriteLn('Dopo overflow: ', N);
  B := 250;
  B := B + 10;
  WriteLn('Byte dopo overflow: ', B);
end.
