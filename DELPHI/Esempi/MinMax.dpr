program MinMax;

{$APPTYPE CONSOLE}

procedure MinMax3(A, B, C: Integer; out Min, Max: Integer);
begin
  Min := A;
  if B < Min then Min := B;
  if C < Min then Min := C;
  Max := A;
  if B > Max then Max := B;
  if C > Max then Max := C;
end;

var
  Mn, Mx: Integer;
begin
  MinMax3(7, 2, 9, Mn, Mx);
  WriteLn(Mn, ' ', Mx);
end.
