{ Serializza - Manuale completo di Free Pascal e Lazarus }
program Serializza;
{$mode objfpc}{$H+}
uses
  Classes, SysUtils;
type
  TPersona = record
    Nome: String;
    Eta: Integer;
  end;
  TPersone = array of TPersona;

procedure Salva(const P: TPersone; const NomeFile: String);
var
  F: TFileStream;
  I, N: Integer;
begin
  F := TFileStream.Create(NomeFile, fmCreate);
  try
    N := Length(P);
    F.WriteBuffer(N, SizeOf(N));
    for I := 0 to High(P) do
    begin
      F.WriteAnsiString(P[I].Nome);
      F.WriteBuffer(P[I].Eta, SizeOf(Integer));
    end;
  finally
    F.Free;
  end;
end;

function Carica(const NomeFile: String): TPersone;
var
  F: TFileStream;
  I, N: Integer;
begin
  F := TFileStream.Create(NomeFile, fmOpenRead);
  try
    F.ReadBuffer(N, SizeOf(N));
    SetLength(Result, N);
    for I := 0 to N - 1 do
    begin
      Result[I].Nome := F.ReadAnsiString;
      F.ReadBuffer(Result[I].Eta, SizeOf(Integer));
    end;
  finally
    F.Free;
  end;
end;

var
  P, Q: TPersone;
  I: Integer;
begin
  SetLength(P, 2);
  P[0].Nome := 'Ada';
  P[0].Eta := 36;
  P[1].Nome := 'Alan';
  P[1].Eta := 41;
  Salva(P, 'persone.bin');
  Q := Carica('persone.bin');
  for I := 0 to High(Q) do
    WriteLn(Q[I].Nome, ', ', Q[I].Eta);
end.
