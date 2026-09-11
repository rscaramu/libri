{ UnitMaschera - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitMaschera;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, DBGrids,
  DBCtrls, db, sqldb, sqlite3conn, Dialogs;

type
  TFormMaschera = class(TForm)
    Conn: TSQLite3Connection;
    Tr: TSQLTransaction;
    Q: TSQLQuery;
    Ds: TDataSource;
    Griglia: TDBGrid;
    Nav: TDBNavigator;
    BtnSalva: TButton;
    procedure BtnSalvaClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject;
                             var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  end;

var
  FormMaschera: TFormMaschera;

implementation

{$R *.lfm}

procedure TFormMaschera.FormCreate(Sender: TObject);
begin
  Conn.DatabaseName := 'libri.db';
  Conn.Transaction := Tr;
  Tr.Database := Conn;
  Q.Database := Conn;
  Q.Transaction := Tr;
  Ds.DataSet := Q;
  Griglia.DataSource := Ds;
  Nav.DataSource := Ds;
  Conn.Open;
  Q.SQL.Text := 'SELECT * FROM libri ORDER BY titolo';
  Q.Open;
end;

procedure TFormMaschera.BtnSalvaClick(Sender: TObject);
begin
  if Q.State in [dsEdit, dsInsert] then
    Q.Post;
  Q.ApplyUpdates;
  Tr.CommitRetaining;
end;

procedure TFormMaschera.FormCloseQuery(Sender: TObject;
                                       var CanClose: Boolean);
begin
  if Q.UpdateStatus <> usUnmodified then
    case MessageDlg('Salvare le modifiche?', mtConfirmation,
                    [mbYes, mbNo, mbCancel], 0) of
      mrYes: BtnSalvaClick(nil);
      mrCancel: CanClose := False;
    end;
end;

end.
