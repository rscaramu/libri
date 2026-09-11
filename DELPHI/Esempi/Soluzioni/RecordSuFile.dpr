program RecordSuFile;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

type
  TMisura = packed record
    Id: Integer;
    Valore: Double;
  end;

var
  FS: TFileStream;
  A, B: array of TMisura;
  N, I: Integer;
begin
  SetLength(A, 3);
  for I := 0 to 2 do
  begin
    A[I].Id := I + 1;
    A[I].Valore := (I + 1) * 0.5;
  end;
  FS := TFileStream.Create('misure.bin', fmCreate);
  try
    N := Length(A);
    FS.WriteBuffer(N, SizeOf(N));
    FS.WriteBuffer(A[0], N * SizeOf(TMisura));
  finally
    FS.Free;
  end;
  FS := TFileStream.Create('misure.bin', fmOpenRead);
  try
    FS.ReadBuffer(N, SizeOf(N));
    SetLength(B, N);
    FS.ReadBuffer(B[0], N * SizeOf(TMisura));
  finally
    FS.Free;
    DeleteFile('misure.bin');
  end;
  for I := 0 to High(B) do
    Write(B[I].Id, ':', B[I].Valore:0:1, ' ');
  WriteLn;
end.
