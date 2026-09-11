program Giorni;

{$APPTYPE CONSOLE}

var
  G: Integer;
begin
  for G := 1 to 8 do
    case G of
      1: WriteLn('lunedi');
      2: WriteLn('martedi');
      3, 4: WriteLn('meta settimana');
      5: WriteLn('venerdi');
      6..7: WriteLn('fine settimana');
    else
      WriteLn('giorno inesistente');
    end;
end.
