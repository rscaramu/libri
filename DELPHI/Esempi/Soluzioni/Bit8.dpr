program Bit8;

{$APPTYPE CONSOLE}

var
  B: Byte;
  I: Integer;
begin
  B := 202;
  for I := 7 downto 0 do
    Write((B shr I) and 1);
  WriteLn;
end.
