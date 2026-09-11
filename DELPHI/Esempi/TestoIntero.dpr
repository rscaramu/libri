program TestoIntero;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

var
  SL: TStringList;
  I: Integer;
begin
  SL := TStringList.Create;
  try
    SL.Add('nome;citta');
    SL.Add('Anna;Roma');
    SL.Add('Luca;Bari');
    SL.SaveToFile('clienti.csv', TEncoding.UTF8);
    SL.Clear;
    SL.LoadFromFile('clienti.csv');
    WriteLn(SL.Count, ' righe');
    for I := 1 to SL.Count - 1 do
      WriteLn(SL[I].Split([';'])[1]);
  finally
    SL.Free;
    DeleteFile('clienti.csv');
  end;
end.
