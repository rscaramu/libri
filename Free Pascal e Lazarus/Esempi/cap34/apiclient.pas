{ ApiClient - Manuale completo di Free Pascal e Lazarus }
unit ApiClient;
{$mode objfpc}{$H+}
interface

uses
  SysUtils, Classes, fphttpclient, fpjson, jsonparser;

type
  EApi = class(Exception)
  private
    FCodice: Integer;
  public
    constructor Create(ACodice: Integer; const Msg: String);
    property Codice: Integer read FCodice;
  end;

  TApiClient = class
  private
    FBase: String;
    FToken: String;
    FTimeout: Integer;
    function Richiesta(const Metodo, Percorso: String;
                       Corpo: TJSONData): TJSONData;
  public
    constructor Create(const ABase: String);
    function Get(const Percorso: String): TJSONData;
    function Post(const Percorso: String;
                  Corpo: TJSONData): TJSONData;
    function Put(const Percorso: String;
                 Corpo: TJSONData): TJSONData;
    procedure Delete(const Percorso: String);
    property Token: String read FToken write FToken;
    property Timeout: Integer read FTimeout write FTimeout;
  end;

implementation

constructor EApi.Create(ACodice: Integer; const Msg: String);
begin
  inherited CreateFmt('HTTP %d: %s', [ACodice, Msg]);
  FCodice := ACodice;
end;

constructor TApiClient.Create(const ABase: String);
begin
  FBase := ABase;
  if (FBase <> '') and (FBase[Length(FBase)] = '/') then
    System.Delete(FBase, Length(FBase), 1);
  FTimeout := 10000;
end;

function TApiClient.Richiesta(const Metodo, Percorso: String;
                              Corpo: TJSONData): TJSONData;
var
  C: TFPHTTPClient;
  Risposta: TStringStream;
  Testo: String;
begin
  Result := nil;
  C := TFPHTTPClient.Create(nil);
  Risposta := TStringStream.Create('');
  try
    C.IOTimeout := FTimeout;
    C.AllowRedirect := True;
    C.AddHeader('Accept', 'application/json');
    if FToken <> '' then
      C.AddHeader('Authorization', 'Bearer ' + FToken);
    if Corpo <> nil then
    begin
      C.AddHeader('Content-Type', 'application/json');
      C.RequestBody := TStringStream.Create(Corpo.AsJSON);
    end;
    try
      try
        C.HTTPMethod(Metodo, FBase + Percorso, Risposta, []);
      except
        on E: Exception do
          raise EApi.Create(0, E.Message);   { rete }
      end;
    finally
      C.RequestBody.Free;
      C.RequestBody := nil;
    end;
    Testo := Risposta.DataString;
    if C.ResponseStatusCode >= 400 then
      raise EApi.Create(C.ResponseStatusCode,
                        Copy(Trim(Testo), 1, 200));
    if Trim(Testo) <> '' then
      try
        Result := GetJSON(Testo);
      except
        on E: Exception do
          raise EApi.Create(C.ResponseStatusCode,
                            'Risposta non JSON: ' +
                            E.Message);
      end;
  finally
    Risposta.Free;
    C.Free;
  end;
end;

function TApiClient.Get(const Percorso: String): TJSONData;
begin
  Result := Richiesta('GET', Percorso, nil);
end;

function TApiClient.Post(const Percorso: String;
                         Corpo: TJSONData): TJSONData;
begin
  Result := Richiesta('POST', Percorso, Corpo);
end;

function TApiClient.Put(const Percorso: String;
                        Corpo: TJSONData): TJSONData;
begin
  Result := Richiesta('PUT', Percorso, Corpo);
end;

procedure TApiClient.Delete(const Percorso: String);
var
  R: TJSONData;
begin
  R := Richiesta('DELETE', Percorso, nil);
  R.Free;
end;

end.
