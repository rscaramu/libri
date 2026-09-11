{ LeggiJson - Manuale completo di Free Pascal e Lazarus }
program LeggiJson;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, fpjson, jsonparser;
const
  Testo =
    '{"nome": "Ada", "eta": 36, "attivo": true,' +
    ' "indirizzo": {"citta": "Londra", "cap": "W1"},' +
    ' "linguaggi": ["Pascal", "Ada", "C"],' +
    ' "note": null}';
var
  J: TJSONData;
  O: TJSONObject;
  A: TJSONArray;
  I: Integer;
begin
  J := GetJSON(Testo);
  try
    O := J as TJSONObject;
    WriteLn('Nome: ', O.Get('nome', ''));
    WriteLn('Eta: ', O.Get('eta', 0));
    WriteLn('Attivo: ', O.Get('attivo', False));
    WriteLn('Citta: ',
            J.FindPath('indirizzo.citta').AsString);
    WriteLn('Telefono: ', O.Get('telefono', 'assente'));
    A := O.Arrays['linguaggi'];
    Write('Linguaggi (', A.Count, '): ');
    for I := 0 to A.Count - 1 do
      Write(A.Strings[I], ' ');
    WriteLn;
    WriteLn('Note nulle? ', O.Nulls['note']);
    WriteLn('Tipo di eta: ', O['eta'].JSONType);
    WriteLn('Secondo linguaggio: ',
            J.FindPath('linguaggi[1]').AsString);
  finally
    J.Free;
  end;
end.
