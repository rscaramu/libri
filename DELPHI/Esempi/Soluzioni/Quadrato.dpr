program Quadrato;

{$APPTYPE CONSOLE}

var
  Lato: Integer;
begin
  { stdin: 7\n }
  ReadLn(Lato);
  WriteLn('Perimetro: ', 4 * Lato);
  WriteLn('Area: ', Lato * Lato);
end.
