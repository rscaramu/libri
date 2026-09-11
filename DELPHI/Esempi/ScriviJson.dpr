program ScriviJson;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.JSON;

var
  Ordine, Riga: TJSONObject;
  Righe: TJSONArray;
begin
  Ordine := TJSONObject.Create;
  try
    Ordine.AddPair('cliente', 'Rossi, Bianchi & C.');
    Ordine.AddPair('importo', TJSONNumber.Create(1250.5));
    Ordine.AddPair('urgente', TJSONBool.Create(True));
    Righe := TJSONArray.Create;
    Ordine.AddPair('righe', Righe);
    Riga := TJSONObject.Create;
    Riga.AddPair('codice', 'A1');
    Riga.AddPair('quantita', TJSONNumber.Create(3));
    Righe.Add(Riga);
    Ordine.AddPair('note', TJSONNull.Create);
    WriteLn(Ordine.ToJSON);
    WriteLn(Ordine.Format(2));
  finally
    Ordine.Free;
  end;
end.
