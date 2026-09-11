{ Saluto - Manuale completo di Free Pascal e Lazarus }
program Saluto;
{$mode objfpc}{$H+}
var
  Nome: String;
begin
  Write('Come vi chiamate? ');
  ReadLn(Nome);
  WriteLn('Benvenuti in Free Pascal, ', Nome, '!');
end.
