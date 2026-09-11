program Fattoriali;

{$APPTYPE CONSOLE}

function Fattoriale(N: Integer): Int64;
var
  I: Integer;
begin
  Result := 1;
  for I := 2 to N do
    Result := Result * I;
end;

var
  N: Integer;
begin
  for N := 0 to 20 do
    if N mod 5 = 0 then
      WriteLn(N, '! = ', Fattoriale(N));
end.
