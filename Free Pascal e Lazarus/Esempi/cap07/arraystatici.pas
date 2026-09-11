{ ArrayStatici - Manuale completo di Free Pascal e Lazarus }
program ArrayStatici;
{$mode objfpc}{$H+}
var
  Temperature: array[1..7] of Double;
  Contatori: array['a'..'e'] of Integer;
  Griglia: array[0..2, 0..2] of Integer;
  I, R, C: Integer;
  Ch: Char;
  Somma: Double;
begin
  for I := 1 to 7 do
    Temperature[I] := 20 + I * 0.5;
  Somma := 0;
  for I := Low(Temperature) to High(Temperature) do
    Somma := Somma + Temperature[I];
  WriteLn('Media: ', Somma / Length(Temperature):0:2);

  for Ch := 'a' to 'e' do
    Contatori[Ch] := Ord(Ch);
  WriteLn('Contatori[''c''] = ', Contatori['c']);

  for R := 0 to 2 do
    for C := 0 to 2 do
      Griglia[R, C] := R * 3 + C;
  for R := 0 to 2 do
  begin
    for C := 0 to 2 do
      Write(Griglia[R, C]:3);
    WriteLn;
  end;
end.
