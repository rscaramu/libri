{ Puntatori1 - Manuale completo di Free Pascal e Lazarus }
program Puntatori1;
{$mode objfpc}{$H+}
type
  PInteger = ^Integer;
var
  N: Integer;
  P, Q: PInteger;
begin
  N := 10;
  P := @N;                { P contiene l'indirizzo di N }
  WriteLn('P^ = ', P^);
  P^ := 20;               { modifica N attraverso P }
  WriteLn('N = ', N);
  Q := P;                 { Q punta allo stesso posto }
  Q^ := Q^ + 1;
  WriteLn('N = ', N, ', P^ = ', P^, ', Q^ = ', Q^);
  WriteLn('P = Q? ', P = Q);
  WriteLn('SizeOf(P) = ', SizeOf(P));
  P := nil;
  WriteLn('P = nil? ', P = nil,
          ', Assigned(Q)? ', Assigned(Q));
end.
