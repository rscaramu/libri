{ ByteDouble - Manuale completo di Free Pascal e Lazarus }
program ByteDouble;
{$mode objfpc}{$H+}
type
  TUnione = record
    case Boolean of
      True: (D: Double);
      False: (B: array[0..7] of Byte);
  end;
var
  U: TUnione;
  I: Integer;
begin
  U.D := 1.0;
  for I := 7 downto 0 do
    Write(HexStr(U.B[I], 2));
  WriteLn;
end.
