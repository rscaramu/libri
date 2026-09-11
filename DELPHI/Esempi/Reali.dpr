program Reali;

{$APPTYPE CONSOLE}

var
  S: Single;
  D: Double;
  C: Currency;
  I: Integer;
begin
  S := 0; D := 0; C := 0;
  for I := 1 to 10 do
  begin
    S := S + 0.1;
    D := D + 0.1;
    C := C + 0.1;
  end;
  WriteLn('Single:   ', S = 1.0);
  WriteLn('Double:   ', D = 1.0);
  WriteLn('Currency: ', C = 1.0);
  WriteLn(D:0:17);
end.
