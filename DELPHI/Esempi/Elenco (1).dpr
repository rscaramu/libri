program Elenco;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

procedure Elenca(const Cartella, Filtro: string);
var
  SR: TSearchRec;
  SL: TStringList;
  S: string;
begin
  SL := TStringList.Create;
  try
    SL.Sorted := True;
    if FindFirst(IncludeTrailingPathDelimiter(Cartella) +
        Filtro, faAnyFile, SR) = 0 then
    try
      repeat
        if SR.Attr and faDirectory = 0 then
          SL.Add(Format('%s (%d byte)', [SR.Name, SR.Size]));
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;
    for S in SL do
      WriteLn(S);
  finally
    SL.Free;
  end;
end;

var
  SL: TStringList;
begin
  ForceDirectories('el');
  SL := TStringList.Create;
  try
    SL.Text := '12345';
    SL.SaveToFile('el/b.dat');
    SL.Text := '1';
    SL.SaveToFile('el/a.dat');
  finally
    SL.Free;
  end;
  Elenca('el', '*.dat');
  DeleteFile('el/a.dat');
  DeleteFile('el/b.dat');
  RemoveDir('el');
end.
