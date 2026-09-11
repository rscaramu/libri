{ UnitColori - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitColori;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, DBGrids, db,
  Grids;

type
  TFormColori = class(TForm)
    Griglia: TDBGrid;
    procedure GrigliaDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
  end;

var
  FormColori: TFormColori;

implementation

{$R *.lfm}

procedure TFormColori.GrigliaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Ds: TDataSet;
begin
  Ds := Column.Field.DataSet;
  if not (gdSelected in State) then
  begin
    if Ds.FieldByName('autore').IsNull then
      Griglia.Canvas.Font.Color := clGray;
    if (Column.FieldName = 'prezzo') and
       (Ds.FieldByName('prezzo').AsFloat > 40) then
      Griglia.Canvas.Font.Color := clRed;
  end;
  Griglia.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

end.
