{ ServerFile - Manuale completo di Free Pascal e Lazarus }
program ServerFile;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, fphttpserver, httpdefs;
type
  TServ = class
    Cartella: String;
    procedure Richiesta(Sender: TObject;
      var ARequest: TFPHTTPConnectionRequest;
      var AResponse: TFPHTTPConnectionResponse);
  end;

function TipoMime(const Ext: String): String;
begin
  case LowerCase(Ext) of
    '.html', '.htm': Result := 'text/html; charset=utf-8';
    '.css':  Result := 'text/css';
    '.js':   Result := 'application/javascript';
    '.png':  Result := 'image/png';
    '.jpg':  Result := 'image/jpeg';
    '.json': Result := 'application/json';
  else
    Result := 'application/octet-stream';
  end;
end;

procedure TServ.Richiesta(Sender: TObject;
  var ARequest: TFPHTTPConnectionRequest;
  var AResponse: TFPHTTPConnectionResponse);
var
  Percorso: String;
begin
  Percorso := ARequest.URI;
  if Percorso = '/' then
    Percorso := '/index.html';
  Percorso := ExpandFileName(Cartella + Percorso);
  if Pos(ExpandFileName(Cartella), Percorso) <> 1 then
  begin
    AResponse.Code := 403;
    AResponse.Content := 'Vietato';
  end
  else if FileExists(Percorso) then
  begin
    AResponse.ContentType :=
      TipoMime(ExtractFileExt(Percorso));
    AResponse.ContentStream :=
      TFileStream.Create(Percorso, fmOpenRead);
    AResponse.FreeContentStream := True;
  end
  else
  begin
    AResponse.Code := 404;
    AResponse.Content := 'Non trovato';
  end;
end;

var
  Server: TFPHTTPServer;
  S: TServ;
begin
  Server := TFPHTTPServer.Create(nil);
  S := TServ.Create;
  try
    S.Cartella := ExtractFilePath(ParamStr(0)) + 'www';
    Server.Port := 8080;
    Server.Threaded := True;
    Server.OnRequest := @S.Richiesta;
    Server.Active := True;
  finally
    S.Free;
    Server.Free;
  end;
end.
