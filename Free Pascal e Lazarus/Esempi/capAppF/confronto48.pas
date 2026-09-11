{ Confronto48 - Manuale completo di Free Pascal e Lazarus }
{ Input di prova (una voce per riga):  7 | 3 }
program Confronto48;
{$mode objfpc}{$H+}
uses
  Math;
var
  A, B: Integer;
begin
  ReadLn(A);
  ReadLn(B);
  case CompareValue(A, B) of
    0: WriteLn('uguali');
    1: WriteLn('il primo e'' maggiore');
  else
    WriteLn('il secondo e'' maggiore');
  end;
end.
