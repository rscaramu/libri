{ Scarica - Manuale completo di Free Pascal e Lazarus }
program Scarica;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, fphttpclient;
type
  TAvanzamento = class
    procedure Ricevuto(Sender: TObject; const ContentLength,
                       CurrentPos: Int64);
  end;

procedure TAvanzamento.Ricevuto(Sender: TObject;
  const ContentLength, CurrentPos: Int64);
begin
  if ContentLength > 0 then
    Write(#13, CurrentPos * 100 div ContentLength, '% ')
  else
    Write(#13, CurrentPos div 1024, ' KB ');
end;

var
  Client: TFPHTTPClient;
  F: TFileStream;
  A: TAvanzamento;
begin
  Client := TFPHTTPClient.Create(nil);
  A := TAvanzamento.Create;
  F := TFileStream.Create('scaricato.bin', fmCreate);
  try
    Client.OnDataReceived := @A.Ricevuto;
    Client.AllowRedirect := True;
    Client.Get('http://localhost:8080/grande.bin', F);
    WriteLn;
    WriteLn('Scaricati ', F.Size, ' byte');
  finally
    F.Free;
    A.Free;
    Client.Free;
  end;
end.
