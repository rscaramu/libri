{ ContaParole - Manuale completo di Free Pascal e Lazarus }
program ContaParole;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, Generics.Collections;
type
  TConteggio = specialize TDictionary<String, Integer>;
var
  D: TConteggio;
  Chiavi: TStringList;
  Testo, Parola: String;
  N: Integer;
begin
  Testo := 'il gatto e il cane e il topo';
  D := TConteggio.Create;
  Chiavi := TStringList.Create;
  try
    for Parola in Testo.Split(' ') do
    begin
      if D.TryGetValue(Parola, N) then
        D[Parola] := N + 1
      else
        D.Add(Parola, 1);
    end;
    for Parola in D.Keys do
      Chiavi.Add(Parola);
    Chiavi.Sort;
    for Parola in Chiavi do
      WriteLn(Parola:6, ' ', D[Parola]);
  finally
    Chiavi.Free;
    D.Free;
  end;
end.
