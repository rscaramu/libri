program LeggiJson;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.JSON;

const
  Testo = '{"cliente":"Rossi, Bianchi & C.",' +
    '"importo":1250.50,' +
    '"urgente":true,"righe":[{"codice":"A1","quantita":3},' +
    '{"codice":"B7","quantita":1}],"note":null}';

var
  Radice: TJSONValue;
  Ordine: TJSONObject;
  Righe: TJSONArray;
  Riga: TJSONValue;
  Note: string;
begin
  Radice := TJSONObject.ParseJSONValue(Testo);
  if Radice = nil then
    raise Exception.Create('JSON non valido');
  try
    Ordine := Radice as TJSONObject;
    WriteLn(Ordine.GetValue<string>('cliente'));
    WriteLn(Ordine.GetValue<Double>('importo'):0:2);
    WriteLn(Ordine.GetValue<Boolean>('urgente'));
    Righe := Ordine.GetValue<TJSONArray>('righe');
    WriteLn(Righe.Count, ' righe');
    for Riga in Righe do
      WriteLn('  ', Riga.GetValue<string>('codice'), ' x ',
        Riga.GetValue<Integer>('quantita'));
    if Ordine.TryGetValue<string>('note', Note) then
      WriteLn('note: ', Note)
    else
      WriteLn('note assenti o null');
    WriteLn(Ordine.GetValue<Integer>('righe[0].quantita'));
    WriteLn(Ordine.FindValue('cliente.inesistente') = nil);
  finally
    Radice.Free;
  end;
end.
