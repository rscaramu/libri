unit Officina.Form.Preventivo;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Collections, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Dialogs,
  Vcl.ActnList, System.Actions,
  Officina.Dominio, Officina.Dati;

type
  TFormPreventivo = class(TForm)
    cbxCliente: TComboBox;
    cbxArticolo: TComboBox;
    edtQuantita: TEdit;
    edtSconto: TEdit;
    lvRighe: TListView;
    lblTotali: TLabel;
    memoAnteprima: TMemo;
    ActionList1: TActionList;
    actAggiungi: TAction;
    actRimuovi: TAction;
    actSalva: TAction;
    actConferma: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actAggiungiExecute(Sender: TObject);
    procedure actAggiungiUpdate(Sender: TObject);
    procedure actRimuoviExecute(Sender: TObject);
    procedure actRimuoviUpdate(Sender: TObject);
    procedure actSalvaExecute(Sender: TObject);
    procedure actConfermaExecute(Sender: TObject);
    procedure actConfermaUpdate(Sender: TObject);
  private
    FRepo: IRepositorio;
    FClienti: TObjectList<TCliente>;
    FArticoli: TObjectList<TArticolo>;
    FPreventivo: TPreventivo;
    procedure NuovoPreventivo;
    procedure Aggiorna;
    function Gestita(E: Exception): Boolean;
  end;

var
  FormPreventivo: TFormPreventivo;

implementation

{$R *.dfm}

uses
  System.IOUtils;

procedure TFormPreventivo.FormCreate(Sender: TObject);
begin
  FRepo := TRepositorioSQLite.Create(
    TPath.Combine(TPath.GetHomePath, 'officina.db'));
  FClienti := FRepo.Clienti;
  FArticoli := FRepo.Articoli;
  for var C in FClienti do
    cbxCliente.Items.AddObject(C.Nome, C);
  for var A in FArticoli do
    cbxArticolo.Items.AddObject(
      A.Codice + ' ' + A.Descrizione, A);
  NuovoPreventivo;
end;

procedure TFormPreventivo.FormDestroy(Sender: TObject);
begin
  FPreventivo.Free;
  FArticoli.Free;
  FClienti.Free;
end;

procedure TFormPreventivo.NuovoPreventivo;
begin
  FreeAndNil(FPreventivo);
  if (cbxCliente.ItemIndex < 0) and
     (cbxCliente.Items.Count > 0) then
    cbxCliente.ItemIndex := 0;
  if cbxCliente.ItemIndex >= 0 then
    FPreventivo := TPreventivo.Create(FRepo.ProssimoNumero,
      TCliente(cbxCliente.Items.Objects[
        cbxCliente.ItemIndex]), Date);
  Aggiorna;
end;

procedure TFormPreventivo.Aggiorna;
begin
  lvRighe.Items.BeginUpdate;
  try
    lvRighe.Items.Clear;
    if FPreventivo = nil then
      Exit;
    for var R in FPreventivo.Righe do
    begin
      var Item := lvRighe.Items.Add;
      Item.Caption := R.Articolo.Codice;
      Item.SubItems.Add(R.Articolo.Descrizione);
      Item.SubItems.Add(R.Quantita.ToString);
      Item.SubItems.Add(R.Sconto.ToString + '%');
      Item.SubItems.Add(FormatCurr('#,##0.00', R.Imponibile));
    end;
  finally
    lvRighe.Items.EndUpdate;
  end;
  lblTotali.Caption := Format(
    'Imponibile %s   IVA %s   Totale %s',
    [FormatCurr('#,##0.00', FPreventivo.Imponibile),
     FormatCurr('#,##0.00', FPreventivo.Iva),
     FormatCurr('#,##0.00', FPreventivo.Totale)]);
  memoAnteprima.Text := FPreventivo.Testo;
  Caption := Format('Preventivo n. %d', [FPreventivo.Numero]);
end;

function TFormPreventivo.Gestita(E: Exception): Boolean;
begin
  Result := E is ECommerciale;
  if Result then
    MessageDlg(E.Message, mtWarning, [mbOK], 0);
end;

procedure TFormPreventivo.actAggiungiExecute(Sender: TObject);
var
  Q, S: Integer;
begin
  Q := StrToIntDef(edtQuantita.Text, 0);
  S := StrToIntDef(edtSconto.Text, 0);
  try
    FPreventivo.Aggiungi(
      TArticolo(cbxArticolo.Items.Objects[
        cbxArticolo.ItemIndex]), Q, S);
    Aggiorna;
  except
    on E: Exception do
      if not Gestita(E) then
        raise;
  end;
end;

procedure TFormPreventivo.actAggiungiUpdate(Sender: TObject);
begin
  actAggiungi.Enabled := (FPreventivo <> nil) and
    not FPreventivo.Confermato and
    (cbxArticolo.ItemIndex >= 0);
end;

procedure TFormPreventivo.actRimuoviExecute(Sender: TObject);
begin
  try
    FPreventivo.Rimuovi(lvRighe.Selected.Index);
    Aggiorna;
  except
    on E: Exception do
      if not Gestita(E) then
        raise;
  end;
end;

procedure TFormPreventivo.actRimuoviUpdate(Sender: TObject);
begin
  actRimuovi.Enabled := (FPreventivo <> nil) and
    not FPreventivo.Confermato and (lvRighe.Selected <> nil);
end;

procedure TFormPreventivo.actSalvaExecute(Sender: TObject);
begin
  FRepo.SalvaPreventivo(FPreventivo);
  ShowMessage('Preventivo salvato');
end;

procedure TFormPreventivo.actConfermaExecute(Sender: TObject);
begin
  try
    FPreventivo.Conferma;
    FRepo.SalvaPreventivo(FPreventivo);
    Aggiorna;
  except
    on E: Exception do
      if not Gestita(E) then
        raise;
  end;
end;

procedure TFormPreventivo.actConfermaUpdate(Sender: TObject);
begin
  actConferma.Enabled := (FPreventivo <> nil) and
    not FPreventivo.Confermato and
    (FPreventivo.Righe.Count > 0);
end;

end.
