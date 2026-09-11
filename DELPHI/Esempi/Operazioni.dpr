program Operazioni;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

var
  SL: TStringList;
  SR: TSearchRec;
  N: Integer;
begin
  ForceDirectories('tmp_prova/sub');
  WriteLn(DirectoryExists('tmp_prova/sub'));
  SL := TStringList.Create;
  try
    SL.Add('uno');
    SL.SaveToFile('tmp_prova/a.txt');
    SL.SaveToFile('tmp_prova/b.txt');
    SL.SaveToFile('tmp_prova/c.log');
  finally
    SL.Free;
  end;
  N := 0;
  if FindFirst('tmp_prova/*.txt', faAnyFile, SR) = 0 then
  try
    repeat
      if SR.Size > 0 then
        Inc(N);
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
  WriteLn(N, ' file .txt');
  WriteLn(RenameFile('tmp_prova/a.txt', 'tmp_prova/z.txt'));
  WriteLn(FileExists('tmp_prova/a.txt'), ' ',
    FileExists('tmp_prova/z.txt'));
  DeleteFile('tmp_prova/z.txt');
  DeleteFile('tmp_prova/b.txt');
  DeleteFile('tmp_prova/c.log');
  WriteLn(RemoveDir('tmp_prova/sub'), ' ',
    RemoveDir('tmp_prova'));
  WriteLn(DirectoryExists('tmp_prova'));
end.
