{ UsaContatore - Manuale completo di Free Pascal e Lazarus }
program UsaContatore;
{$mode objfpc}{$H+}
uses
  Contatore;
begin
  Incrementa;
  Incrementa(10);
  WriteLn(Valore);
  Azzera;
  WriteLn(Valore);
  { FValore := 5;  -> Error: Identifier not found "FValore" }
end.
