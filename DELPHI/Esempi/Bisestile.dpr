program Bisestile;

{$APPTYPE CONSOLE}

var
  Anno: Integer;
  B: Boolean;
begin
  for Anno := 1896 to 2024 do
  begin
    B := ((Anno mod 4 = 0) and (Anno mod 100 <> 0))
      or (Anno mod 400 = 0);
    if B and (Anno mod 100 = 0) or (Anno = 1896) then
      WriteLn(Anno, ' ', B);
  end;
end.
