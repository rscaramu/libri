program Registro;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

const
  NomeLog = 'app.log';
  MaxByte = 60;

procedure Registra(const Msg: string);
var
  FS: TFileStream;
  B: TBytes;
  Modo: Word;
begin
  if FileExists(NomeLog) then
    Modo := fmOpenReadWrite
  else
    Modo := fmCreate;
  FS := TFileStream.Create(NomeLog, Modo or fmShareDenyWrite);
  try
    if FS.Size > MaxByte then
    begin
      FS.Size := 0;
      B := TEncoding.UTF8.GetBytes('[rotazione]' +
        sLineBreak);
      FS.WriteBuffer(B[0], Length(B));
    end;
    FS.Seek(0, soEnd);
    B := TEncoding.UTF8.GetBytes(Msg + sLineBreak);
    FS.WriteBuffer(B[0], Length(B));
  finally
    FS.Free;
  end;
end;

var
  I: Integer;
  SL: TStringList;
begin
  DeleteFile(NomeLog);
  for I := 1 to 6 do
    Registra(Format('evento numero %d', [I]));
  SL := TStringList.Create;
  try
    SL.LoadFromFile(NomeLog, TEncoding.UTF8);
    WriteLn(SL.Count, ' righe');
    WriteLn(SL[0]);
    WriteLn(SL[SL.Count - 1]);
  finally
    SL.Free;
    DeleteFile(NomeLog);
  end;
end.
