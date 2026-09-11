{ Rubrica - Manuale completo di Free Pascal e Lazarus }
program Rubrica;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TContatto = record
    Nome: String[40];
    Telefono: String[20];
  end;
var
  F: file of TContatto;
  C: TContatto;

procedure Aggiungi(const N, T: String);
begin
  if FileExists('rubrica.dat') then
    Reset(F)
  else
    Rewrite(F);
  Seek(F, FileSize(F));         { in coda }
  C.Nome := N;
  C.Telefono := T;
  Write(F, C);
  CloseFile(F);
end;

begin
  AssignFile(F, 'rubrica.dat');
  if FileExists('rubrica.dat') then
    DeleteFile('rubrica.dat');  { partiamo da zero }
  Aggiungi('Rossi Mario', '333 1234567');
  Aggiungi('Bianchi Anna', '02 9876543');
  Reset(F);
  WriteLn('Contatti: ', FileSize(F));
  while not EOF(F) do
  begin
    Read(F, C);
    WriteLn(C.Nome:20, '  ', C.Telefono);
  end;
  CloseFile(F);
end.
