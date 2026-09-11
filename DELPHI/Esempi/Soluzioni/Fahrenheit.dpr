program Fahrenheit;

{$APPTYPE CONSOLE}

var
  C: Integer;
  F: Real;
begin
  { stdin: 37\n }
  ReadLn(C);
  F := C * 9 / 5 + 32;
  WriteLn(F:0:1);
end.
