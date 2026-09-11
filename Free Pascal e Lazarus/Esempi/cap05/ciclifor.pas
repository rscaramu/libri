{ CicliFor - Manuale completo di Free Pascal e Lazarus }
program CicliFor;
{$mode objfpc}{$H+}
var
  I, Somma: Integer;
  S: String;
  C: Char;
begin
  Somma := 0;
  for I := 1 to 100 do
    Somma := Somma + I;
  WriteLn('Somma 1..100 = ', Somma);
  for I := 5 downto 1 do
    Write(I, ' ');
  WriteLn;
  for I := 3 to 1 do
    WriteLn('mai eseguito');
  S := 'Pascal';
  for C in S do
    Write(UpCase(C));
  WriteLn;
  for I := Length(S) downto 1 do
    Write(S[I]);
  WriteLn;
end.
