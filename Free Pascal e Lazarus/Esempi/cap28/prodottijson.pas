{ ProdottiJson - Manuale completo di Free Pascal e Lazarus }
program ProdottiJson;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, fpjson, jsonparser, Generics.Collections,
  Generics.Defaults;
type
  TProdotto = class
    Nome: String;
    Prezzo: Double;
    Disponibile: Boolean;
  end;
  TProdotti = specialize TObjectList<TProdotto>;
const
  Testo = '[{"nome":"Tastiera","prezzo":45.0,' +
          '  "disponibile":true},' +
          ' {"nome":"Mouse","prezzo":19.5,' +
          '  "disponibile":true},' +
          ' {"nome":"Monitor","prezzo":199,' +
          '  "disponibile":false},' +
          ' {"nome":"Cavo","prezzo":5}]';

function PerPrezzo(constref A, B: TProdotto): Integer;
begin
  if A.Prezzo < B.Prezzo then
    Result := -1
  else if A.Prezzo > B.Prezzo then
    Result := 1
  else
    Result := 0;
end;

var
  J: TJSONData;
  A: TJSONArray;
  O: TJSONObject;
  L: TProdotti;
  P: TProdotto;
  I: Integer;
begin
  L := TProdotti.Create(True);
  J := GetJSON(Testo);
  try
    A := J as TJSONArray;
    for I := 0 to A.Count - 1 do
    begin
      O := A.Objects[I];
      P := TProdotto.Create;
      P.Nome := O.Get('nome', '?');
      P.Prezzo := O.Get('prezzo', 0.0);
      P.Disponibile := O.Get('disponibile', False);
      L.Add(P);
    end;
  finally
    J.Free;
  end;
  try
    L.Sort(specialize TComparer<TProdotto>.Construct(
             @PerPrezzo));
    for P in L do
      if P.Disponibile then
        WriteLn(P.Nome:10, P.Prezzo:8:2);
  finally
    L.Free;
  end;
end.
