program ProvaTextFile;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  F: TextFile;
  Riga: string;
  N: Integer;
begin
  AssignFile(F, 'righe.txt');
  Rewrite(F);
  try
    WriteLn(F, 'alfa');
    WriteLn(F, 'beta');
    WriteLn(F, 'gamma');
  finally
    CloseFile(F);
  end;
  AssignFile(F, 'righe.txt');
  Reset(F);
  try
    N := 0;
    while not Eof(F) do
    begin
      ReadLn(F, Riga);
      Inc(N);
      WriteLn(N, ': ', Riga);
    end;
  finally
    CloseFile(F);
  end;
  DeleteFile('righe.txt');
end.
