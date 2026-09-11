{ ScriviJson - Manuale completo di Free Pascal e Lazarus }
program ScriviJson;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, fpjson;
var
  Radice, Ind: TJSONObject;
  Ling: TJSONArray;
  L: TStringList;
begin
  Radice := TJSONObject.Create;
  try
    Radice.Add('nome', 'Grace');
    Radice.Add('eta', 45);
    Radice.Add('altezza', 1.5);
    Radice.Add('attiva', True);
    Ind := TJSONObject.Create;
    Ind.Add('citta', 'New York');
    Radice.Add('indirizzo', Ind);
    Ling := TJSONArray.Create;
    Ling.Add('COBOL');
    Ling.Add('FLOW-MATIC');
    Radice.Add('linguaggi', Ling);
    Radice.Add('note', TJSONNull.Create);
    WriteLn(Radice.FormatJSON);
    Radice.Integers['eta'] := 46;
    Radice.Delete('note');
    WriteLn(Radice.Count, ' membri, eta ',
            Radice.Integers['eta']);
    WriteLn(Ind.AsJSON);
    TJSONData.CompressedJSON := True;
    WriteLn(Ind.AsJSON);
    L := TStringList.Create;
    try
      L.Text := Radice.FormatJSON;
      L.SaveToFile('persona.json');
    finally
      L.Free;
    end;
  finally
    Radice.Free;
  end;
end.
