program RestoPositivo;

{$APPTYPE CONSOLE}

var
  A, B: Integer;
begin
  A := -7; B := 3;
  WriteLn(A mod B, ' ', ((A mod B) + B) mod B);
end.
