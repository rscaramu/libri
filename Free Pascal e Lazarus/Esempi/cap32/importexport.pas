{ ImportExport - Manuale completo di Free Pascal e Lazarus }
unit ImportExport;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, db;

type
  TSalvaContatto = function(Id: Integer; const Nome, Cognome,
    Telefono, Email: String; GruppoId: Integer): Integer
    of object;

function ImportaCsv(const NomeFile: String;
                    Salva: TSalvaContatto): Integer;
procedure EsportaCsv(const NomeFile: String; Ds: TDataSet);

implementation

uses
  csvdocument;

function ImportaCsv(const NomeFile: String;
                    Salva: TSalvaContatto): Integer;
var
  Csv: TCSVDocument;
  R, Prima: Integer;
begin
  Result := 0;
  Csv := TCSVDocument.Create;
  try
    Csv.Delimiter := ';';
    Csv.LoadFromFile(NomeFile);
    Prima := 0;
    if (Csv.RowCount > 0) and
       SameText(Csv.Cells[0, 0], 'cognome') then
      Prima := 1;                  { salta l'intestazione }
    for R := Prima to Csv.RowCount - 1 do
      if Csv.ColCount[R] >= 2 then
      begin
        Salva(0, Trim(Csv.Cells[1, R]), Trim(Csv.Cells[0, R]),
              Trim(Csv.Cells[2, R]), Trim(Csv.Cells[3, R]),
              -1);
        Inc(Result);
      end;
  finally
    Csv.Free;
  end;
end;

procedure EsportaCsv(const NomeFile: String; Ds: TDataSet);
var
  Csv: TCSVDocument;
  R: Integer;
  Segnalibro: TBookmark;
begin
  Csv := TCSVDocument.Create;
  try
    Csv.Delimiter := ';';
    Csv.AddRow('cognome');
    Csv.AddCell(0, 'nome');
    Csv.AddCell(0, 'telefono');
    Csv.AddCell(0, 'email');
    Csv.AddCell(0, 'gruppo');
    R := 1;
    Ds.DisableControls;
    Segnalibro := Ds.GetBookmark;
    try
      Ds.First;
      while not Ds.EOF do
      begin
        Csv.AddRow(Ds.FieldByName('cognome').AsString);
        Csv.AddCell(R, Ds.FieldByName('nome').AsString);
        Csv.AddCell(R, Ds.FieldByName('telefono').AsString);
        Csv.AddCell(R, Ds.FieldByName('email').AsString);
        Csv.AddCell(R, Ds.FieldByName('gruppo').AsString);
        Inc(R);
        Ds.Next;
      end;
    finally
      Ds.GotoBookmark(Segnalibro);
      Ds.FreeBookmark(Segnalibro);
      Ds.EnableControls;
    end;
    Csv.SaveToFile(NomeFile);
  finally
    Csv.Free;
  end;
end;

end.
