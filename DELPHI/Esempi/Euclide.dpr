program Euclide;

{$APPTYPE CONSOLE}

function MCD(A, B: Integer): Integer;
var
  R: Integer;
begin
  while B <> 0 do
  begin
    R := A mod B;
    A := B;
    B := R;
  end;
  Result := A;
end;

begin
  WriteLn(MCD(48, 18), ' ', MCD(17, 5), ' ', MCD(100, 75));
end.
