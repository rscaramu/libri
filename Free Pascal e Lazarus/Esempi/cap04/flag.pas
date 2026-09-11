{ Flag - Manuale completo di Free Pascal e Lazarus }
program Flag;
{$mode objfpc}{$H+}
const
  fModificato = 1;
  fSolaLettura = 2;
  fCondiviso = 4;
var
  Stato: Byte = 0;
begin
  Stato := Stato or fModificato;
  Stato := Stato or fCondiviso;
  WriteLn('Modificato: ', (Stato and fModificato) <> 0);
  WriteLn('Sola lettura: ', (Stato and fSolaLettura) <> 0);
  Stato := Stato and not fModificato;  { azzera un flag }
  WriteLn('Modificato: ', (Stato and fModificato) <> 0);
  WriteLn('Stato finale: %', BinStr(Stato, 3));
end.
