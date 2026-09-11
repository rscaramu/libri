{ Bit - Manuale completo di Free Pascal e Lazarus }
program Bit;
{$mode objfpc}{$H+}
const
  FlagLettura  = 1;   { %0001 }
  FlagScrittura = 2;  { %0010 }
  FlagEsecuzione = 4; { %0100 }
var
  Permessi: Byte;
begin
  Permessi := FlagLettura or FlagScrittura;
  WriteLn('Permessi = ', Permessi, ' (binario %',
          BinStr(Permessi, 4), ')');
  WriteLn('Lettura?    ', (Permessi and FlagLettura) <> 0);
  WriteLn('Esecuzione? ',
          (Permessi and FlagEsecuzione) <> 0);
  Permessi := Permessi xor FlagLettura;  { toglie la lettura }
  WriteLn('Dopo xor: %', BinStr(Permessi, 4));
  WriteLn('1 shl 10 = ', 1 shl 10);
  WriteLn('$FF shr 4 = $', HexStr($FF shr 4, 2));
  WriteLn('not 0 (Byte) = ', Byte(not Byte(0)));
end.
