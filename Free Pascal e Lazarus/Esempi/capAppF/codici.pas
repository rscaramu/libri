{ Codici - Manuale completo di Free Pascal e Lazarus }
{ Input di prova (una voce per riga):  m }
program Codici;
{$mode objfpc}{$H+}
var
  C: Char;
begin
  ReadLn(C);
  WriteLn('Codice: ', Ord(C), ', successivo: ', Succ(C),
          ', precedente: ', Pred(C));
end.
