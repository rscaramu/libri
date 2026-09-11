program PerRiferimento;

{$APPTYPE CONSOLE}

procedure Scambia(var A, B: Integer);
var
  T: Integer;
begin
  T := A;
  A := B;
  B := T;
end;

var
  X, Y: Integer;
begin
  X := 1; Y := 2;
  Scambia(X, Y);
  WriteLn(X, ' ', Y);
end.
