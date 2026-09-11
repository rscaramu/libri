program Eratostene;

{$APPTYPE CONSOLE}

var
  Candidati: set of Byte;
  I, J, N: Integer;
begin
  Candidati := [2..255];
  for I := 2 to 15 do
    if I in Candidati then
    begin
      J := I * I;
      while J <= 255 do
      begin
        Exclude(Candidati, J);
        J := J + I;
      end;
    end;
  N := 0;
  for I := 2 to 255 do
    if I in Candidati then
    begin
      Inc(N);
      if I < 30 then
        Write(I, ' ');
    end;
  WriteLn('... ', N, ' primi');
end.
