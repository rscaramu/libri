{ Buongiorno - Manuale completo di Free Pascal e Lazarus }
{ Input di prova (una voce per riga):  Ada | Lovelace }
program Buongiorno;
{$mode objfpc}{$H+}
var
  Nome, Cognome: String;
begin
  ReadLn(Nome);
  ReadLn(Cognome);
  WriteLn('Buongiorno, ', Nome, ' ', Cognome);
end.
