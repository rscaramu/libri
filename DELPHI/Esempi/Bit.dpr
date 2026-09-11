program Bit;

{$APPTYPE CONSOLE}

var
  A, B: Byte;
begin
  A := $CA;  // 11001010
  B := $B3;  // 10110011
  WriteLn(A and B, ' ', A or B, ' ', A xor B);
  WriteLn(not A, ' ', A shl 1, ' ', A shr 2);
  WriteLn(1 shl 10);
  WriteLn($FF and $0F);
end.
