{ UnitLibri - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitLibri;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, DBGrids,
  DBCtrls, ExtCtrls, db, DataModuloLibri;

type
  TFormLibri = class(TForm)
    Griglia: TDBGrid;
    Navigatore: TDBNavigator;
    PnlDettaglio: TPanel;
    EdtTitolo: TDBEdit;
    EdtAutore: TDBEdit;
    EdtAnno: TDBEdit;
    LblTitolo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure GrigliaTitleClick(Column: TColumn);
  end;

var
  FormLibri: TFormLibri;

implementation

{$R *.lfm}

procedure TFormLibri.FormCreate(Sender: TObject);
begin
  Griglia.DataSource := DmLibri.DsLibri;
  Navigatore.DataSource := DmLibri.DsLibri;
  EdtTitolo.DataSource := DmLibri.DsLibri;
  EdtTitolo.DataField := 'titolo';
  EdtAutore.DataSource := DmLibri.DsLibri;
  EdtAutore.DataField := 'autore';
  EdtAnno.DataSource := DmLibri.DsLibri;
  EdtAnno.DataField := 'anno';
  Griglia.Options := Griglia.Options + [dgRowSelect];
  Griglia.Options := Griglia.Options - [dgEditing];
end;

procedure TFormLibri.GrigliaTitleClick(Column: TColumn);
begin
  with DmLibri.QLibri do
  begin
    Close;
    SQL.Text := 'SELECT * FROM libri ORDER BY ' +
                Column.FieldName;
    Open;
  end;
end;

end.
