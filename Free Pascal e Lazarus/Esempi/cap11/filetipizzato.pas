{ FileTipizzato - Manuale completo di Free Pascal e Lazarus }
program FileTipizzato;
{$mode objfpc}{$H+}
type
  TArticolo = record
    Codice: Integer;
    Nome: String[30];
    Prezzo: Currency;
  end;
var
  F: file of TArticolo;
  A: TArticolo;
  I: Integer;
begin
  AssignFile(F, 'articoli.dat');
  Rewrite(F);
  for I := 1 to 3 do
  begin
    A.Codice := 100 + I;
    A.Nome := 'Articolo ' + Chr(Ord('A') + I - 1);
    A.Prezzo := I * 9.99;
    Write(F, A);
  end;
  WriteLn('Record scritti: ', FileSize(F));
  WriteLn('Byte per record: ', SizeOf(TArticolo));

  Seek(F, 1);                 { il secondo record (da 0) }
  Read(F, A);
  WriteLn('Record 1: ', A.Codice, ' ', A.Nome, ' ',
          A.Prezzo:0:2);

  A.Prezzo := 5;              { lo modifica sul posto }
  Seek(F, 1);
  Write(F, A);
  CloseFile(F);

  Reset(F);
  while not EOF(F) do
  begin
    Read(F, A);
    WriteLn(A.Codice, ' ', A.Nome:12, A.Prezzo:8:2);
  end;
  CloseFile(F);
end.
