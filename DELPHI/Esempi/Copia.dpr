program Copia;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

function CopiaFile(const Da, A: string): Boolean;
var
  Src, Dst: TFileStream;
begin
  Src := TFileStream.Create(Da,
    fmOpenRead or fmShareDenyWrite);
  try
    Dst := TFileStream.Create(A, fmCreate);
    try
      Dst.CopyFrom(Src, 0);
      Result := Dst.Size = Src.Size;
    finally
      Dst.Free;
    end;
  finally
    Src.Free;
  end;
end;

var
  MS: TMemoryStream;
  I: Integer;
begin
  MS := TMemoryStream.Create;
  try
    for I := 1 to 1000 do
      MS.WriteBuffer(I, SizeOf(I));
    MS.SaveToFile('orig.bin');
  finally
    MS.Free;
  end;
  WriteLn(CopiaFile('orig.bin', 'copia.bin'));
  DeleteFile('orig.bin');
  DeleteFile('copia.bin');
end.
