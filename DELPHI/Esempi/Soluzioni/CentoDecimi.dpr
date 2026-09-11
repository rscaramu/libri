program CentoDecimi;

{$APPTYPE CONSOLE}

var
  D: Double;
  C: Currency;
  I: Integer;
begin
  D := 0; C := 0;
  for I := 1 to 100 do
  begin
    D := D + 0.1;
    C := C + 0.1;
  end;
  WriteLn(D:0:14);
  WriteLn(C:0:4);
  WriteLn(D = 10, ' ', C = 10);
end.
