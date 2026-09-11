{ SommaProdotto - Manuale completo di Free Pascal e Lazarus }
{ Input di prova (una voce per riga):  6 | 7 }
program SommaProdotto;
{$mode objfpc}{$H+}
var
  A, B: Integer;
begin
  Write('Primo numero: ');
  ReadLn(A);
  Write('Secondo numero: ');
  ReadLn(B);
  WriteLn('Somma = ', A + B);
  WriteLn('Prodotto = ', A * B);
end.
