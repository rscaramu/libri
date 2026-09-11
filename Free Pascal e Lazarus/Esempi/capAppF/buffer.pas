{ Buffer - Manuale completo di Free Pascal e Lazarus }
program Buffer;
{$mode objfpc}{$H+}
var
  P: PByte;
  I: Integer;
begin
  GetMem(P, 1024);
  FillChar(P^, 1024, 65);
  for I := 0 to 9 do
    Write(Chr(P[I]));
  WriteLn;
  FreeMem(P);
end.
