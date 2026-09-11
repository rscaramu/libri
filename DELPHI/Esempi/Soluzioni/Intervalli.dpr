program Intervalli;

{$APPTYPE CONSOLE}

begin
  WriteLn('SmallInt ', SizeOf(SmallInt), ' ', Low(SmallInt),
    ' ', High(SmallInt));
  WriteLn('Word ', SizeOf(Word), ' ', Low(Word), ' ',
    High(Word));
  WriteLn('Cardinal ', SizeOf(Cardinal), ' ', Low(Cardinal),
    ' ', High(Cardinal));
  WriteLn('UInt64 ', SizeOf(UInt64), ' ', Low(UInt64), ' ',
    High(UInt64));
end.
