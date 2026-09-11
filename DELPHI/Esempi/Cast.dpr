program Cast;

{$APPTYPE CONSOLE}

var
  I: Integer;
  B: Byte;
  C: Char;
begin
  I := 300;
  B := Byte(I);
  WriteLn(B);
  C := Char(66);
  WriteLn(C);
  I := Integer('z');
  WriteLn(I);
end.
