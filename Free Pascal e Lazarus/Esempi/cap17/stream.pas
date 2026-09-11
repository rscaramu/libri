{ Stream - Manuale completo di Free Pascal e Lazarus }
program Stream;
{$mode objfpc}{$H+}
uses
  Classes, SysUtils;
var
  F: TFileStream;
  M: TMemoryStream;
  N: Integer;
  D: Double;
  S: String;
  L: TStringList;
begin
  F := TFileStream.Create('dati.bin', fmCreate);
  try
    N := 42;
    D := 3.14;
    S := 'ciao';
    F.WriteBuffer(N, SizeOf(N));
    F.WriteBuffer(D, SizeOf(D));
    F.WriteAnsiString(S);      { lunghezza + byte }
    WriteLn('Scritti ', F.Size, ' byte');
  finally
    F.Free;
  end;

  F := TFileStream.Create('dati.bin', fmOpenRead);
  try
    F.ReadBuffer(N, SizeOf(N));
    F.ReadBuffer(D, SizeOf(D));
    S := F.ReadAnsiString;
    WriteLn(N, ' ', D:0:2, ' ', S, ' pos=', F.Position);
  finally
    F.Free;
  end;

  M := TMemoryStream.Create;
  L := TStringList.Create;
  try
    L.Add('riga 1');
    L.Add('riga 2');
    L.SaveToStream(M);
    WriteLn('In memoria: ', M.Size, ' byte');
    M.Position := 0;
    L.Clear;
    L.LoadFromStream(M);
    WriteLn(L[1]);
    M.SaveToFile('righe.txt');
  finally
    L.Free;
    M.Free;
  end;
end.
