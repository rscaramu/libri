{ FormPrincipale - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit FormPrincipale;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, DBGrids,
  ExtCtrls, Menus, ActnList, ComCtrls, Dialogs, db,
  XMLPropStorage, DataModulo, FormContatto, ImportExport;

type
  TFrmPrincipale = class(TForm)
    Azioni: TActionList;
    ActNuovo: TAction;
    ActModifica: TAction;
    ActElimina: TAction;
    ActImporta: TAction;
    ActEsporta: TAction;
    ActEsci: TAction;
    MainMenu: TMainMenu;
    MnuFile: TMenuItem;
    MnuContatti: TMenuItem;
    PnlRicerca: TPanel;
    EdtRicerca: TEdit;
    CmbGruppo: TComboBox;
    Griglia: TDBGrid;
    BarraStato: TStatusBar;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Storage: TXMLPropStorage;
    TimerRicerca: TTimer;
    procedure ActEliminaExecute(Sender: TObject);
    procedure ActEsciExecute(Sender: TObject);
    procedure ActEsportaExecute(Sender: TObject);
    procedure ActImportaExecute(Sender: TObject);
    procedure ActModificaExecute(Sender: TObject);
    procedure ActModificaUpdate(Sender: TObject);
    procedure ActNuovoExecute(Sender: TObject);
    procedure CmbGruppoChange(Sender: TObject);
    procedure EdtRicercaChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GrigliaDblClick(Sender: TObject);
    procedure TimerRicercaTimer(Sender: TObject);
  private
    procedure CaricaGruppi;
    procedure Aggiorna(IdDaSelezionare: Integer = 0);
    function GruppoScelto: Integer;
    function IdCorrente: Integer;
  end;

var
  FrmPrincipale: TFrmPrincipale;

implementation

{$R *.lfm}

procedure TFrmPrincipale.FormCreate(Sender: TObject);
begin
  Storage.FileName := GetAppConfigDir(False) + 'finestra.xml';
  SessionProperties := 'Left;Top;Width;Height';
  Griglia.DataSource := DmRubrica.DsContatti;
  Griglia.Options := Griglia.Options + [dgRowSelect] -
                     [dgEditing];
  TimerRicerca.Interval := 300;
  TimerRicerca.Enabled := False;
  CaricaGruppi;
  Aggiorna;
end;

procedure TFrmPrincipale.CaricaGruppi;
begin
  CmbGruppo.Items.Clear;
  CmbGruppo.Items.AddObject('Tutti i gruppi',
                            TObject(PtrInt(-1)));
  DmRubrica.QGruppi.First;
  while not DmRubrica.QGruppi.EOF do
  begin
    CmbGruppo.Items.AddObject(
      DmRubrica.QGruppi.FieldByName('nome').AsString,
      TObject(PtrInt(DmRubrica.QGruppi.FieldByName('id')
                     .AsInteger)));
    DmRubrica.QGruppi.Next;
  end;
  CmbGruppo.ItemIndex := 0;
end;

function TFrmPrincipale.GruppoScelto: Integer;
begin
  if CmbGruppo.ItemIndex < 0 then
    Result := -1
  else
    Result := PtrInt(CmbGruppo.Items.Objects[
                       CmbGruppo.ItemIndex]);
end;

function TFrmPrincipale.IdCorrente: Integer;
begin
  if DmRubrica.QContatti.Active and
     not DmRubrica.QContatti.IsEmpty then
    Result := DmRubrica.QContatti.FieldByName('id').AsInteger
  else
    Result := 0;
end;

procedure TFrmPrincipale.Aggiorna(IdDaSelezionare: Integer);
begin
  DmRubrica.Cerca(Trim(EdtRicerca.Text), GruppoScelto);
  if IdDaSelezionare > 0 then
    DmRubrica.QContatti.Locate('id', IdDaSelezionare, []);
  BarraStato.SimpleText := Format('%d contatti',
    [DmRubrica.QContatti.RecordCount]);
end;

procedure TFrmPrincipale.EdtRicercaChange(Sender: TObject);
begin
  TimerRicerca.Enabled := False;
  TimerRicerca.Enabled := True;
end;

procedure TFrmPrincipale.TimerRicercaTimer(Sender: TObject);
begin
  TimerRicerca.Enabled := False;
  Aggiorna(IdCorrente);
end;

procedure TFrmPrincipale.CmbGruppoChange(Sender: TObject);
begin
  Aggiorna;
end;

procedure TFrmPrincipale.ActNuovoExecute(Sender: TObject);
var
  Id: Integer;
begin
  Id := 0;
  if TFrmContatto.Modifica(Id) then
    Aggiorna(Id);
end;

procedure TFrmPrincipale.ActModificaExecute(Sender: TObject);
var
  Id: Integer;
begin
  Id := IdCorrente;
  if (Id > 0) and TFrmContatto.Modifica(Id) then
    Aggiorna(Id);
end;

procedure TFrmPrincipale.ActModificaUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := IdCorrente > 0;
end;

procedure TFrmPrincipale.GrigliaDblClick(Sender: TObject);
begin
  ActModifica.Execute;
end;

procedure TFrmPrincipale.ActEliminaExecute(Sender: TObject);
var
  Id: Integer;
begin
  Id := IdCorrente;
  if Id = 0 then
    Exit;
  if MessageDlg('Eliminare ' +
       DmRubrica.QContatti.FieldByName('cognome').AsString +
       ' ' +
       DmRubrica.QContatti.FieldByName('nome').AsString + '?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DmRubrica.EliminaContatto(Id);
    Aggiorna;
  end;
end;

procedure TFrmPrincipale.ActImportaExecute(Sender: TObject);
var
  N: Integer;
begin
  OpenDialog.Filter := 'File CSV|*.csv|Tutti i file|*';
  if OpenDialog.Execute then
  begin
    N := ImportaCsv(OpenDialog.FileName,
                    @DmRubrica.SalvaContatto);
    Aggiorna;
    MessageDlg(Format('Importati %d contatti', [N]),
               mtInformation, [mbOk], 0);
  end;
end;

procedure TFrmPrincipale.ActEsportaExecute(Sender: TObject);
begin
  SaveDialog.Filter := 'File CSV|*.csv';
  SaveDialog.DefaultExt := 'csv';
  if SaveDialog.Execute then
  begin
    EsportaCsv(SaveDialog.FileName, DmRubrica.QContatti);
    BarraStato.SimpleText := 'Esportato in ' +
      ExtractFileName(SaveDialog.FileName);
  end;
end;

procedure TFrmPrincipale.ActEsciExecute(Sender: TObject);
begin
  Close;
end;

end.
