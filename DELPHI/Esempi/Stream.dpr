program Stream;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

type
  TRecord = packed record
    Id: Integer;
    Valore: Double;
    Attivo: Boolean;
  end;

var
  FS: TFileStream;
  MS: TMemoryStream;
  R: TRecord;
  I: Integer;
begin
  FS := TFileStream.Create('dati.bin', fmCreate);
  try
    for I := 1 to 3 do
    begin
      R.Id := I;
      R.Valore := I * 1.5;
      R.Attivo := Odd(I);
      FS.WriteBuffer(R, SizeOf(R));
    end;
    WriteLn(FS.Size, ' byte, ', SizeOf(TRecord),
      ' per record');
  finally
    FS.Free;
  end;
  FS := TFileStream.Create('dati.bin',
    fmOpenRead or fmShareDenyWrite);
  try
    FS.Position := SizeOf(TRecord);
    FS.ReadBuffer(R, SizeOf(R));
    WriteLn(R.Id, ' ', R.Valore:0:1, ' ', R.Attivo);
    MS := TMemoryStream.Create;
    try
      FS.Position := 0;
      MS.CopyFrom(FS, FS.Size);
      WriteLn(MS.Size, ' ', MS.Position);
      MS.Position := 2 * SizeOf(TRecord);
      MS.ReadBuffer(R, SizeOf(R));
      WriteLn(R.Id);
    finally
      MS.Free;
    end;
  finally
    FS.Free;
    DeleteFile('dati.bin');
  end;
end.
