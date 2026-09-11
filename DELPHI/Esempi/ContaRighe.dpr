program ContaRighe;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

function ContaRighe(const Nome: string): Integer;
var
  F: TextFile;
  Riga: string;
begin
  Result := 0;
  AssignFile(F, Nome);
  Reset(F);
  try
    while not Eof(F) do
    begin
      ReadLn(F, Riga);
      Inc(Result);
    end;
  finally
    CloseFile(F);
  end;
end;

var
  SL: TStringList;
  I: Integer;
begin
  SL := TStringList.Create;
  try
    for I := 1 to 1000 do
      SL.Add('riga ' + IntToStr(I));
    SL.SaveToFile('mille.txt');
  finally
    SL.Free;
  end;
  WriteLn(ContaRighe('mille.txt'));
  DeleteFile('mille.txt');
end.
