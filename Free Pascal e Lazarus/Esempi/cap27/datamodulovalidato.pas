{ DataModuloValidato - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit DataModuloValidato;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, db;

type
  TDmValidato = class(TDataModule)
    Conn: TSQLite3Connection;
    Tr: TSQLTransaction;
    Q: TSQLQuery;
    Ds: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure QBeforePost(DataSet: TDataSet);
    procedure QNewRecord(DataSet: TDataSet);
    procedure QCalcFields(DataSet: TDataSet);
  end;

var
  DmValidato: TDmValidato;

implementation

{$R *.lfm}

procedure TDmValidato.DataModuleCreate(Sender: TObject);
var
  F: TField;
begin
  Conn.DatabaseName := 'libri.db';
  Conn.Transaction := Tr;
  Tr.Database := Conn;
  Q.Database := Conn;
  Q.Transaction := Tr;
  Ds.DataSet := Q;
  Conn.Open;
  Q.SQL.Text := 'SELECT * FROM libri';
  { campo calcolato definito da codice }
  Q.FieldDefs.Update;
  Q.FieldDefs.Add('prezzo_iva', ftFloat);
  F := TFloatField.Create(Q);
  F.FieldName := 'prezzo_iva';
  F.FieldKind := fkCalculated;
  F.DataSet := Q;
  F.DisplayLabel := 'Prezzo con IVA';
  TFloatField(F).DisplayFormat := '#,##0.00';
  Q.Open;
end;

procedure TDmValidato.QNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('anno').AsInteger := 2026;
  DataSet.FieldByName('prezzo').AsFloat := 0;
end;

procedure TDmValidato.QBeforePost(DataSet: TDataSet);
begin
  if Trim(DataSet.FieldByName('titolo').AsString) = '' then
    DatabaseError('Il titolo e'' obbligatorio');
  if DataSet.FieldByName('prezzo').AsFloat < 0 then
    DatabaseError('Il prezzo non puo'' essere negativo');
end;

procedure TDmValidato.QCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('prezzo_iva').AsFloat :=
    DataSet.FieldByName('prezzo').AsFloat * 1.22;
end;

end.
