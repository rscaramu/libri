{ CsvSeparatore - Manuale completo di Free Pascal e Lazarus }
program CsvSeparatore;
{$mode objfpc}{$H+}
uses
  SysUtils, Classes, csvdocument;
var
  Csv: TCSVDocument;
  L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Add('nome,indirizzo');
    L.Add('"Rossi, Mario","Via Roma 1, Torino"');
    L.SaveToFile('in.csv');
  finally
    L.Free;
  end;
  Csv := TCSVDocument.Create;
  try
    Csv.Delimiter := ',';
    Csv.LoadFromFile('in.csv');
    WriteLn(Csv.Cells[1, 1]);
    Csv.Delimiter := ';';
    Csv.SaveToFile('out.csv');
    L := TStringList.Create;
    try
      L.LoadFromFile('out.csv');
      WriteLn(L[1]);
    finally
      L.Free;
    end;
  finally
    Csv.Free;
  end;
end.
