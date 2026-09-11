program DimensioneCartella;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

function DimensioneCartella(const Percorso: string): Int64;
var
  SR: TSearchRec;
  Base: string;
begin
  Result := 0;
  Base := IncludeTrailingPathDelimiter(Percorso);
  if FindFirst(Base + '*', faAnyFile, SR) = 0 then
  try
    repeat
      if (SR.Name = '.') or (SR.Name = '..') then
        Continue;
      if SR.Attr and faDirectory <> 0 then
        Result := Result + DimensioneCartella(Base + SR.Name)
      else
        Result := Result + SR.Size;
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
end;

var
  SL: TStringList;
begin
  ForceDirectories('dc/sub');
  SL := TStringList.Create;
  try
    SL.Text := '12345';
    SL.SaveToFile('dc/a.txt');
    SL.SaveToFile('dc/sub/b.txt');
  finally
    SL.Free;
  end;
  WriteLn(DimensioneCartella('dc') > 0);
  DeleteFile('dc/a.txt');
  DeleteFile('dc/sub/b.txt');
  RemoveDir('dc/sub');
  RemoveDir('dc');
end.
