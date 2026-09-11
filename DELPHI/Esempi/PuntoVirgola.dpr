program PuntoVirgola;

{$APPTYPE CONSOLE}

var
  X: Integer;
begin
  X := 3;
  if X > 2 then
    WriteLn('grande')
  else
    WriteLn('piccolo');
  if X > 2 then
  begin
    WriteLn('grande');
    WriteLn('davvero')
  end;
  WriteLn('fine')
end.
