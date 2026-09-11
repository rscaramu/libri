program Errori;

{$APPTYPE CONSOLE}

var
  N: Integer;
begin
  N := 10;
  if N > 5 then
    WriteLn('grande')
  else
    WriteLn('piccolo');
end.
