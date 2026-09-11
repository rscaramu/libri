{ Copia - Manuale completo di Free Pascal e Lazarus }
program Copia;
{$mode objfpc}{$H+}
var
  Sorgente, Destinazione: file;
  Buffer: array[0..4095] of Byte;
  Letti, Totale: Integer;
begin
  AssignFile(Sorgente, 'articoli.dat');
  AssignFile(Destinazione, 'copia.dat');
  Reset(Sorgente, 1);
  Rewrite(Destinazione, 1);
  Totale := 0;
  repeat
    BlockRead(Sorgente, Buffer, SizeOf(Buffer), Letti);
    if Letti > 0 then
      BlockWrite(Destinazione, Buffer, Letti);
    Totale := Totale + Letti;
  until Letti = 0;
  CloseFile(Sorgente);
  CloseFile(Destinazione);
  WriteLn('Copiati ', Totale, ' byte');
end.
