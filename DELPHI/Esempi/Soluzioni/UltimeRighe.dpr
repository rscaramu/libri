program UltimeRighe;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

function UltimeRighe(const Nome: string;
  N: Integer): TArray<string>;
var
  SL: TStringList;
  I, Da: Integer;
begin
  SL := TStringList.Create;
  try
    SL.LoadFromFile(Nome);
    Da := SL.Count - N;
    if Da < 0 then
      Da := 0;
    Result := nil;
    for I := Da to SL.Count - 1 do
      Result := Result + [SL[I]];
  finally
    SL.Free;
  end;
end;

var
  SL: TStringList;
  I: Integer;
begin
  SL := TStringList.Create;
  try
    for I := 1 to 100 do
      SL.Add('riga ' + IntToStr(I));
    SL.SaveToFile('cento.txt');
  finally
    SL.Free;
  end;
  WriteLn(string.Join(',', UltimeRighe('cento.txt', 3)));
  DeleteFile('cento.txt');
end.
