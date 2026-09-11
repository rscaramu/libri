{ ProvaAnalisi - Manuale completo di Free Pascal e Lazarus }
program ProvaAnalisi;
{$mode objfpc}{$H+}
uses
  SysUtils, Compilazione;
const
  Righe: array[0..3] of String = (
    'unit1.pas(12,5) Error: Identifier not found "x"',
    'unit1.pas(30,12) Warning: Variable "i" does not seem ' +
      'to be initialized',
    'Free Pascal Compiler version 3.2.2',
    'prog.lpr(4,1) Note: Local variable "y" not used');
var
  R: String;
  M: TMessaggioCompilatore;
begin
  for R in Righe do
    if AnalizzaRiga(R, M) then
      WriteLn(M.Tipo:8, ' ', M.NomeFile, ':', M.Riga, ':',
              M.Colonna, ' ', Copy(M.Testo, 1, 30))
    else
      WriteLn('       - ', Copy(R, 1, 30));
end.
