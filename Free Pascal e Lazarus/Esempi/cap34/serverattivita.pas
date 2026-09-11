{ ServerAttivita - Manuale completo di Free Pascal e Lazarus }
unit ServerAttivita;
{$mode objfpc}{$H+}
interface

uses
  SysUtils, Classes, fphttpserver, httpdefs, httpprotocol,
  fpjson, jsonparser, SyncObjs;

type
  TServerAttivita = class
  private
    FServer: TFPHTTPServer;
    FDati: TJSONArray;
    FLock: TCriticalSection;
    FProssimoId: Integer;
    FToken: String;
    procedure Richiesta(Sender: TObject;
      var ARequest: TFPHTTPConnectionRequest;
      var AResponse: TFPHTTPConnectionResponse);
    procedure Json(var AResponse: TFPHTTPConnectionResponse;
                   Codice: Integer; Dati: TJSONData);
    function TrovaIndice(Id: Integer): Integer;
  public
    constructor Create(Porta: Word; const AToken: String);
    destructor Destroy; override;
    procedure Avvia;      { bloccante }
    procedure Ferma;
  end;

implementation

constructor TServerAttivita.Create(Porta: Word;
                                   const AToken: String);
begin
  FServer := TFPHTTPServer.Create(nil);
  FServer.Port := Porta;
  FServer.OnRequest := @Richiesta;
  FServer.AcceptIdleTimeout := 500;   { vedi sotto }
  FDati := TJSONArray.Create;
  FLock := TCriticalSection.Create;
  FProssimoId := 1;
  FToken := AToken;
end;

destructor TServerAttivita.Destroy;
begin
  FServer.Free;
  FDati.Free;
  FLock.Free;
  inherited;
end;

procedure TServerAttivita.Avvia;
begin
  FServer.Active := True;
end;

procedure TServerAttivita.Ferma;
begin
  FServer.Active := False;
end;

procedure TServerAttivita.Json(
  var AResponse: TFPHTTPConnectionResponse; Codice: Integer;
  Dati: TJSONData);
begin
  AResponse.Code := Codice;
  AResponse.ContentType := 'application/json';
  if Dati <> nil then
    AResponse.Content := Dati.AsJSON
  else
    AResponse.Content := '{}';
end;

function TServerAttivita.TrovaIndice(Id: Integer): Integer;
var
  I: Integer;
begin
  for I := 0 to FDati.Count - 1 do
    if FDati.Objects[I].Get('id', 0) = Id then
      Exit(I);
  Result := -1;
end;

procedure TServerAttivita.Richiesta(Sender: TObject;
  var ARequest: TFPHTTPConnectionRequest;
  var AResponse: TFPHTTPConnectionResponse);
var
  Parti: TStringArray;
  Id, I: Integer;
  Corpo: TJSONData;
  O: TJSONObject;
begin
  if ARequest.GetHeader(hhAuthorization) <>
     'Bearer ' + FToken then
  begin
    Json(AResponse, 401, nil);
    Exit;
  end;
  Parti := ARequest.URI.Split('/', TStringSplitOptions.
                              ExcludeEmpty);
  FLock.Enter;
  try
    if (Length(Parti) = 1) and (Parti[0] = 'attivita') then
    begin
      if ARequest.Method = 'GET' then
        Json(AResponse, 200, FDati)
      else if ARequest.Method = 'POST' then
      begin
        Corpo := GetJSON(ARequest.Content);
        try
          O := TJSONObject.Create;
          O.Add('id', FProssimoId);
          O.Add('titolo', Corpo.FindPath('titolo').AsString);
          O.Add('completata', False);
          Inc(FProssimoId);
          FDati.Add(O);
          Json(AResponse, 201, O);
        finally
          Corpo.Free;
        end;
      end
      else
        Json(AResponse, 405, nil);
    end
    else if (Length(Parti) >= 2) and
            (Parti[0] = 'attivita') and
            TryStrToInt(Parti[1], Id) then
    begin
      I := TrovaIndice(Id);
      if I < 0 then
        Json(AResponse, 404, nil)
      else if (ARequest.Method = 'PUT') and
              (Length(Parti) = 3) and
              (Parti[2] = 'completa') then
      begin
        FDati.Objects[I].Booleans['completata'] := True;
        Json(AResponse, 200, FDati.Objects[I]);
      end
      else if ARequest.Method = 'DELETE' then
      begin
        FDati.Delete(I);
        Json(AResponse, 204, nil);
      end
      else
        Json(AResponse, 405, nil);
    end
    else
      Json(AResponse, 404, nil);
  finally
    FLock.Leave;
  end;
end;

end.
