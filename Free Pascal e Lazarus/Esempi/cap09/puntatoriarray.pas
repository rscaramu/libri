{ PuntatoriArray - Manuale completo di Free Pascal e Lazarus }
program PuntatoriArray;
{$mode objfpc}{$H+}
{$POINTERMATH ON}
var
  A: array[0..4] of Integer = (10, 20, 30, 40, 50);
  P: PInteger;
  I: Integer;
begin
  P := @A[0];
  for I := 0 to 4 do
  begin
    Write(P^, ' ');
    Inc(P);
  end;
  WriteLn;
  P := @A[0];
  WriteLn('P[2] = ', P[2], ', (P + 4)^ = ', (P + 4)^);
  WriteLn('Distanza in byte: ',
          PtrUInt(@A[4]) - PtrUInt(@A[0]));
end.
