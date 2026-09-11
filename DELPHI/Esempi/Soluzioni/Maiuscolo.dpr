program Maiuscolo;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

var
  SL: TStringList;
  I: Integer;
begin
  SL := TStringList.Create;
  try
    SL.Add('prima riga');
    SL.Add('seconda riga');
    SL.SaveToFile('in.txt', TEncoding.UTF8);
    SL.Clear;
    SL.LoadFromFile('in.txt', TEncoding.UTF8);
    for I := 0 to SL.Count - 1 do
      SL[I] := UpperCase(SL[I]);
    SL.SaveToFile('out.txt', TEncoding.UTF8);
    SL.Clear;
    SL.LoadFromFile('out.txt', TEncoding.UTF8);
    WriteLn(SL[1]);
  finally
    SL.Free;
    DeleteFile('in.txt');
    DeleteFile('out.txt');
  end;
end.
