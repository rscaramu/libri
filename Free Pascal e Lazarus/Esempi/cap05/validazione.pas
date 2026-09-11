{ Validazione - Manuale completo di Free Pascal e Lazarus }
{ Input di prova (una voce per riga):  0 | 15 | 7 }
program Validazione;
{$mode objfpc}{$H+}
var
  N: Integer;
begin
  repeat
    Write('Numero da 1 a 10: ');
    ReadLn(N);
    if (N < 1) or (N > 10) then
      WriteLn('Non valido, riprovate.');
  until (N >= 1) and (N <= 10);
  WriteLn('Grazie, avete scelto ', N);
end.
