{ Meteo - Manuale completo di Free Pascal e Lazarus }
program Meteo;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, fphttpclient, opensslsockets, fpjson,
  jsonparser;
const
  URL = 'https://api.open-meteo.com/v1/forecast' +
        '?latitude=37.5&longitude=15.1' +
        '&current=temperature_2m';
var
  J: TJSONData;
  T: TJSONData;
begin
  J := GetJSON(TFPHTTPClient.SimpleGet(URL));
  try
    T := J.FindPath('current.temperature_2m');
    if Assigned(T) then
      WriteLn('Temperatura: ', T.AsFloat:0:1, ' gradi')
    else
      WriteLn('Campo non trovato');
  finally
    J.Free;
  end;
end.
