program PrimoPrimo;

{$APPTYPE CONSOLE}

function EPrimo(N: Integer): Boolean;
var
  D: Integer;
begin
  if N < 2 then
    Exit(False);
  for D := 2 to N - 1 do
    if N mod D = 0 then
      Exit(False);
  Result := True;
end;

var
  I: Integer;
begin
  for I := 1 to 30 do
  begin
    if I mod 2 = 0 then
      Continue;
    if I > 20 then
      Break;
    if EPrimo(I) then
      Write(I, ' ');
  end;
  WriteLn;
end.
