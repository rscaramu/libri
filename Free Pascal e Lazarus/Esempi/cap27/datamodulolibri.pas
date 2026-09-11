{ DataModuloLibri - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit DataModuloLibri;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, db;

type
  TDmLibri = class(TDataModule)
    Conn: TSQLite3Connection;
    Tr: TSQLTransaction;
    QLibri: TSQLQuery;
    DsLibri: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure QLibriAfterPost(DataSet: TDataSet);
  public
    procedure Salva;
  end;

var
  DmLibri: TDmLibri;

implementation

{$R *.lfm}

procedure TDmLibri.DataModuleCreate(Sender: TObject);
begin
  Conn.DatabaseName := 'libri.db';
  Conn.Transaction := Tr;
  Tr.Database := Conn;
  QLibri.Database := Conn;
  QLibri.Transaction := Tr;
  DsLibri.DataSet := QLibri;
  Conn.Open;
  Conn.ExecuteDirect('CREATE TABLE IF NOT EXISTS libri (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'titolo VARCHAR(100) NOT NULL, autore VARCHAR(60), ' +
    'anno INTEGER, prezzo REAL)');
  Tr.Commit;
  QLibri.SQL.Text := 'SELECT * FROM libri ORDER BY titolo';
  QLibri.Open;
end;

procedure TDmLibri.QLibriAfterPost(DataSet: TDataSet);
begin
  Salva;
end;

procedure TDmLibri.Salva;
begin
  QLibri.ApplyUpdates;
  Tr.CommitRetaining;
end;

end.
