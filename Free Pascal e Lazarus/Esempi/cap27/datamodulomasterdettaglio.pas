{ DataModuloMasterDettaglio - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit DataModuloMasterDettaglio;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, db;

type
  TDmMD = class(TDataModule)
    Conn: TSQLite3Connection;
    Tr: TSQLTransaction;
    QAutori: TSQLQuery;
    QLibri: TSQLQuery;
    DsAutori: TDataSource;
    DsLibri: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  end;

var
  DmMD: TDmMD;

implementation

{$R *.lfm}

procedure TDmMD.DataModuleCreate(Sender: TObject);
begin
  Conn.DatabaseName := 'biblioteca.db';
  Conn.Transaction := Tr;
  Tr.Database := Conn;
  QAutori.Database := Conn;
  QAutori.Transaction := Tr;
  QLibri.Database := Conn;
  QLibri.Transaction := Tr;
  DsAutori.DataSet := QAutori;
  DsLibri.DataSet := QLibri;
  Conn.Open;
  QAutori.SQL.Text := 'SELECT id, nome FROM autori ' +
                      'ORDER BY nome';
  QLibri.SQL.Text := 'SELECT * FROM libri ' +
                     'WHERE autore_id = :id';
  QLibri.DataSource := DsAutori;    { master }
  QAutori.Open;
  QLibri.Open;
end;

end.
