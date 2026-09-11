program Triangolo;

{$APPTYPE CONSOLE}

var
  A, B, C: Integer;
begin
  A := 3; B := 4; C := 5;
  WriteLn((A < B + C) and (B < A + C) and (C < A + B));
  C := 8;
  WriteLn((A < B + C) and (B < A + C) and (C < A + B));
end.
