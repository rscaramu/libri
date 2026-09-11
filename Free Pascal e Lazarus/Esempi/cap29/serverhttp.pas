{ ServerHttp - Manuale completo di Free Pascal e Lazarus }
program ServerHttp;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, fphttpserver, httpdefs, fpjson;
type
  TGestore = class
    Utenti: Integer;
    procedure Richiesta(Sender: TObject;
      var ARequest: TFPHTTPConnectionRequest;
      var AResponse: TFPHTTPConnectionResponse);
  end;

procedure TGestore.Richiesta(Sender: TObject;
  var ARequest: TFPHTTPConnectionRequest;
  var AResponse: TFPHTTPConnectionResponse);
var
  J: TJSONObject;
begin
  WriteLn(ARequest.Method, ' ', ARequest.URI);
  if ARequest.URI = '/api/info' then
  begin
    J := TJSONObject.Create;
    try
      J.Add('versione', '1.2');
      J.Add('utenti', Utenti);
      AResponse.ContentType := 'application/json';
      AResponse.Content := J.AsJSON;
    finally
      J.Free;
    end;
  end
  else if (ARequest.Method = 'POST') and
          (ARequest.URI = '/api/utenti') then
  begin
    Inc(Utenti);
    AResponse.Code := 201;
    AResponse.ContentType := 'application/json';
    AResponse.Content := '{"id":' + IntToStr(Utenti) + '}';
  end
  else
  begin
    AResponse.Code := 404;
    AResponse.Content := 'Non trovato: ' + ARequest.URI;
  end;
end;

var
  Server: TFPHTTPServer;
  G: TGestore;
begin
  Server := TFPHTTPServer.Create(nil);
  G := TGestore.Create;
  try
    Server.Port := 8080;
    Server.OnRequest := @G.Richiesta;
    WriteLn('In ascolto sulla porta 8080, Ctrl+C per uscire');
    Server.Active := True;
  finally
    G.Free;
    Server.Free;
  end;
end.
