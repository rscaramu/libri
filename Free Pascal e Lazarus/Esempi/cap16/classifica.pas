{ Classifica - Manuale completo di Free Pascal e Lazarus }
program Classifica;
{$mode objfpc}{$H+}
uses
  SysUtils, Generics.Collections, Generics.Defaults;
type
  TStudente = class
    Cognome: String;
    Media: Double;
    constructor Create(const AC: String; AM: Double);
  end;
  TStudenti = specialize TObjectList<TStudente>;
  TComparatore = specialize TComparer<TStudente>;

constructor TStudente.Create(const AC: String; AM: Double);
begin
  Cognome := AC;
  Media := AM;
end;

function Confronta(constref A, B: TStudente): Integer;
begin
  if A.Media > B.Media then
    Result := -1
  else if A.Media < B.Media then
    Result := 1
  else
    Result := CompareStr(A.Cognome, B.Cognome);
end;

var
  L: TStudenti;
  S: TStudente;
begin
  L := TStudenti.Create;
  try
    L.Add(TStudente.Create('Rossi', 7.5));
    L.Add(TStudente.Create('Bianchi', 8.0));
    L.Add(TStudente.Create('Alberti', 7.5));
    L.Add(TStudente.Create('Verdi', 9.0));
    L.Sort(TComparatore.Construct(@Confronta));
    for S in L do
      WriteLn(S.Cognome:10, S.Media:6:1);
  finally
    L.Free;
  end;
end.
