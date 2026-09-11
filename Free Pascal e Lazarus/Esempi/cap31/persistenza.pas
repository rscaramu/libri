{ Persistenza - Manuale completo di Free Pascal e Lazarus }
unit Persistenza;
{$mode objfpc}{$H+}
interface

uses
  SysUtils, Classes, Modello;

procedure SalvaElenco(E: TElencoAttivita;
                      const NomeFile: String);
procedure CaricaElenco(E: TElencoAttivita;
                       const NomeFile: String);

implementation

uses
  fpjson, jsonparser, DateUtils;

function DataATesto(D: TDateTime): String;
begin
  if D = 0 then
    Result := ''
  else
    Result := FormatDateTime('yyyy-mm-dd', D);
end;

procedure SalvaElenco(E: TElencoAttivita;
                      const NomeFile: String);
var
  Radice, O: TJSONObject;
  Arr: TJSONArray;
  A: TAttivita;
  L: TStringList;
begin
  Radice := TJSONObject.Create;
  L := TStringList.Create;
  try
    Radice.Add('versione', 1);
    Radice.Add('prossimo_id', E.ProssimoId);
    Arr := TJSONArray.Create;
    Radice.Add('attivita', Arr);
    for A in E.Elementi do
    begin
      O := TJSONObject.Create;
      O.Add('id', A.Id);
      O.Add('titolo', A.Titolo);
      O.Add('priorita', TestoPriorita(A.Priorita));
      O.Add('scadenza', DataATesto(A.Scadenza));
      O.Add('completata', A.Completata);
      O.Add('creata', DateTimeToUnix(A.Creata));
      Arr.Add(O);
    end;
    ForceDirectories(ExtractFilePath(NomeFile));
    L.Text := Radice.FormatJSON;
    L.SaveToFile(NomeFile);
  finally
    L.Free;
    Radice.Free;
  end;
end;

procedure CaricaElenco(E: TElencoAttivita;
                       const NomeFile: String);
var
  J: TJSONData;
  Radice, O: TJSONObject;
  Arr: TJSONArray;
  A: TAttivita;
  L: TStringList;
  I: Integer;
begin
  E.Svuota;
  if not FileExists(NomeFile) then
    Exit;
  L := TStringList.Create;
  try
    L.LoadFromFile(NomeFile);
    J := GetJSON(L.Text);
  finally
    L.Free;
  end;
  try
    Radice := J as TJSONObject;
    Arr := Radice.Get('attivita', TJSONArray(nil));
    if Arr <> nil then
      for I := 0 to Arr.Count - 1 do
      begin
        O := Arr.Objects[I];
        A := E.Aggiungi(O.Get('titolo', ''),
                        PrioritaDaTesto(O.Get('priorita',
                                              'normale')),
                        DataDaTesto(O.Get('scadenza', '')));
        A.Id := O.Get('id', A.Id);
        A.Completata := O.Get('completata', False);
        A.Creata := UnixToDateTime(O.Get('creata', Int64(0)));
      end;
    E.ProssimoId := Radice.Get('prossimo_id', E.ProssimoId);
  finally
    J.Free;
  end;
end;

end.
