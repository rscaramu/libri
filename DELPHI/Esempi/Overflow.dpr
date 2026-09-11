program Overflow;

{$APPTYPE CONSOLE}

var
  N: Integer;
  B: Byte;
begin
  N := High(Integer);
  N := N + 1;
  WriteLn(N);
  B := 250;
  B := B + 10;
  WriteLn(B);
end.
