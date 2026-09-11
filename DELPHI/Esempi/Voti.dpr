program Voti;

{$APPTYPE CONSOLE}

var
  Voto: Integer;
begin
  for Voto := 3 to 10 do
  begin
    Write(Voto, ': ');
    if Voto < 6 then
      WriteLn('insufficiente')
    else if Voto < 8 then
      WriteLn('sufficiente')
    else if Voto < 10 then
      WriteLn('buono')
    else
      WriteLn('ottimo');
  end;
end.
