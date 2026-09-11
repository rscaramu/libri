{ Dimensioni - Manuale completo di Free Pascal e Lazarus }
program Dimensioni;
{$mode objfpc}{$H+}
begin
  WriteLn('Byte      : ', SizeOf(Byte), ' byte');
  WriteLn('SmallInt  : ', SizeOf(SmallInt), ' byte');
  WriteLn('Integer   : ', SizeOf(Integer), ' byte');
  WriteLn('Int64     : ', SizeOf(Int64), ' byte');
  WriteLn('NativeInt : ', SizeOf(NativeInt), ' byte');
  WriteLn('Massimo Integer: ', High(Integer));
  WriteLn('Minimo Integer : ', Low(Integer));
end.
