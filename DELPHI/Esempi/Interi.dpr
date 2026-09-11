program Interi;

{$APPTYPE CONSOLE}

begin
  WriteLn('Integer: ', SizeOf(Integer), ' byte, da ',
    Low(Integer), ' a ', High(Integer));
  WriteLn('Byte: ', SizeOf(Byte), ' byte, da ',
    Low(Byte), ' a ', High(Byte));
  WriteLn('Int64: ', SizeOf(Int64), ' byte, massimo ',
    High(Int64));
end.
