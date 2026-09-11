{ UnitLookup - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitLookup;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, DBCtrls, DBGrids, db,
  sqldb, sqlite3conn;

type
  TFormLookup = class(TForm)
    Conn: TSQLite3Connection;
    Tr: TSQLTransaction;
    QProdotti: TSQLQuery;
    QCategorie: TSQLQuery;
    DsProdotti: TDataSource;
    DsCategorie: TDataSource;
    Griglia: TDBGrid;
    CmbCategoria: TDBLookupComboBox;
    procedure FormCreate(Sender: TObject);
  end;

var
  FormLookup: TFormLookup;

implementation

{$R *.lfm}

procedure TFormLookup.FormCreate(Sender: TObject);
begin
  Conn.DatabaseName := 'negozio.db';
  Conn.Transaction := Tr;
  Tr.Database := Conn;
  QProdotti.Database := Conn;
  QProdotti.Transaction := Tr;
  QCategorie.Database := Conn;
  QCategorie.Transaction := Tr;
  DsProdotti.DataSet := QProdotti;
  DsCategorie.DataSet := QCategorie;
  Conn.Open;
  QCategorie.SQL.Text := 'SELECT id, nome FROM categorie';
  QProdotti.SQL.Text := 'SELECT * FROM prodotti';
  QCategorie.Open;
  QProdotti.Open;
  Griglia.DataSource := DsProdotti;
  CmbCategoria.DataSource := DsProdotti;
  CmbCategoria.DataField := 'categoria_id';
  CmbCategoria.ListSource := DsCategorie;
  CmbCategoria.KeyField := 'id';
  CmbCategoria.ListField := 'nome';
end;

end.
