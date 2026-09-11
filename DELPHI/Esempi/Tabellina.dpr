program Tabellina;

{$APPTYPE CONSOLE}

var
  I, J: Integer;
begin
  for I := 1 to 3 do
  begin
    for J := 1 to 5 do
      Write(I * J:4);
    WriteLn;
  end;
  for I := 5 downto 1 do
    Write(I, ' ');
  WriteLn;
end.
