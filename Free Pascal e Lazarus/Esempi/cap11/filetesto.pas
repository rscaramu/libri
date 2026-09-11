{ FileTesto - Manuale completo di Free Pascal e Lazarus }
program FileTesto;
{$mode objfpc}{$H+}
var
  F: TextFile;
  Riga: String;
  N, Somma: Integer;
begin
  AssignFile(F, 'numeri.txt');
  Rewrite(F);
  for N := 1 to 5 do
    WriteLn(F, N * 10);
  CloseFile(F);

  Append(F);
  WriteLn(F, 60);
  CloseFile(F);

  Reset(F);
  Somma := 0;
  while not EOF(F) do
  begin
    ReadLn(F, N);
    Somma := Somma + N;
  end;
  CloseFile(F);
  WriteLn('Somma: ', Somma);

  Reset(F);
  while not EOF(F) do
  begin
    ReadLn(F, Riga);
    Write('[', Riga, '] ');
  end;
  CloseFile(F);
  WriteLn;
end.
