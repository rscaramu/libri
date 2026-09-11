{ Appiattisci - Manuale completo di Free Pascal e Lazarus }
program Appiattisci;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, fpjson, jsonparser;

procedure JsonToStringList(J: TJSONData;
                           const Prefisso: String;
                           L: TStrings);
var
  I: Integer;
  P: String;
begin
  case J.JSONType of
    jtObject:
      for I := 0 to J.Count - 1 do
      begin
        if Prefisso = '' then
          P := TJSONObject(J).Names[I]
        else
          P := Prefisso + '.' + TJSONObject(J).Names[I];
        JsonToStringList(J.Items[I], P, L);
      end;
    jtArray:
      for I := 0 to J.Count - 1 do
        JsonToStringList(J.Items[I],
          Prefisso + '[' + IntToStr(I) + ']', L);
  else
    L.Add(Prefisso + '=' + J.AsString);
  end;
end;

var
  J: TJSONData;
  L: TStringList;
begin
  J := GetJSON('{"a":1,"b":{"c":"x","d":[true,2]}}');
  L := TStringList.Create;
  try
    JsonToStringList(J, '', L);
    WriteLn(L.Text);
  finally
    L.Free;
    J.Free;
  end;
end.
