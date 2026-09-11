{ ConIva - Manuale completo di Free Pascal e Lazarus }
{ Input di prova (una voce per riga):  100 }
program ConIva;
{$mode objfpc}{$H+}
const
  IVA = 22;
var
  Prezzo, Totale: Currency;
begin
  ReadLn(Prezzo);
  Totale := Prezzo + Prezzo * IVA / 100;
  WriteLn('Totale con IVA: ', Totale:0:2);
end.
