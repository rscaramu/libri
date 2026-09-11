program Precedenza;

{$APPTYPE CONSOLE}

var
  A, B: Integer;
begin
  A := 5; B := 3;
  WriteLn(A + B * 2);
  WriteLn((A + B) * 2);
  WriteLn(10 - 4 - 3, ' ', 20 div 4 * 2);
  WriteLn((A > 0) and (B > 0));
  WriteLn(not (A = B), ' ', A <> B);
  WriteLn(-A * B, ' ', -(A * B));
end.
