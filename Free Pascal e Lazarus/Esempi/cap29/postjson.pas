{ PostJson - Manuale completo di Free Pascal e Lazarus }
program PostJson;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, fphttpclient, fpjson;
var
  Client: TFPHTTPClient;
  Corpo: TJSONObject;
  Risposta: String;
begin
  Client := TFPHTTPClient.Create(nil);
  Corpo := TJSONObject.Create;
  try
    Corpo.Add('nome', 'Ada');
    Corpo.Add('eta', 36);
    Client.AddHeader('Content-Type', 'application/json');
    Client.RequestBody := TStringStream.Create(Corpo.AsJSON);
    try
      Risposta :=
        Client.Post('http://localhost:8080/api/utenti');
    finally
      Client.RequestBody.Free;
      Client.RequestBody := nil;
    end;
    WriteLn(Client.ResponseStatusCode, ': ', Risposta);
  finally
    Corpo.Free;
    Client.Free;
  end;
end.
