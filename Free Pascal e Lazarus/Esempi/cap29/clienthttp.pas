{ ClientHttp - Manuale completo di Free Pascal e Lazarus }
program ClientHttp;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, fphttpclient, fpjson, jsonparser;
var
  Client: TFPHTTPClient;
  Risposta: String;
  J: TJSONData;
begin
  Client := TFPHTTPClient.Create(nil);
  try
    Client.AddHeader('User-Agent', 'ManualeFPC/1.0');
    Client.AddHeader('Accept', 'application/json');
    Client.AllowRedirect := True;
    Client.IOTimeout := 10000;          { millisecondi }
    Risposta := Client.Get('http://localhost:8080/api/info');
    WriteLn('Stato: ', Client.ResponseStatusCode, ' ',
            Client.ResponseStatusText);
    WriteLn('Tipo: ',
            Client.ResponseHeaders.Values['Content-Type']);
    J := GetJSON(Risposta);
    try
      WriteLn('Versione: ', J.FindPath('versione').AsString);
      WriteLn('Utenti: ', J.FindPath('utenti').AsInteger);
    finally
      J.Free;
    end;
  finally
    Client.Free;
  end;
end.
