program Prevedi;

{$APPTYPE CONSOLE}

var
  A: Integer;
  B: Double;
  C: Byte;
begin
  A := 7;
  B := A / 2;
  C := A div 2;
  WriteLn(B:0:1, ' ', C);
  WriteLn(SizeOf(A) + SizeOf(B) + SizeOf(C));
  WriteLn(Round(B), ' ', Trunc(B));
end.
