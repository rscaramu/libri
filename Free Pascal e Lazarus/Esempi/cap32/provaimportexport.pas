{ ProvaImportExport - Manuale completo di Free Pascal e Lazarus }
program ProvaImportExport;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, ImportExport;
type
  TFinto = class
    Conteggio: Integer;
    function Salva(Id: Integer; const Nome, Cognome, Telefono,
      Email: String; GruppoId: Integer): Integer;
  end;

function TFinto.Salva(Id: Integer; const Nome, Cognome,
  Telefono, Email: String; GruppoId: Integer): Integer;
begin
  Inc(Conteggio);
  WriteLn('  salvo ', Cognome, ' ', Nome, ' <', Email, '>');
  Result := Conteggio;
end;

var
  L: TStringList;
  F: TFinto;
  N: Integer;
begin
  L := TStringList.Create;
  F := TFinto.Create;
  try
    L.Add('cognome;nome;telefono;email');
    L.Add('Rossi;Mario;333 111;mario@esempio.it');
    L.Add('"Bianchi; Neri";Anna;;anna@esempio.it');
    L.Add('Verdi;Luca');
    L.Add(';;;');
    L.SaveToFile('contatti.csv');
    N := ImportaCsv('contatti.csv', @F.Salva);
    WriteLn('Importati: ', N);
  finally
    F.Free;
    L.Free;
  end;
end.
