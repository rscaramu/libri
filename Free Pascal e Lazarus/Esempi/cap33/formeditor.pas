{ FormEditor - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit FormEditor;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls,
  Menus, ActnList, Dialogs, ExtCtrls, Graphics, LCLType,
  SynEdit, SynEditTypes, Documento, Compilazione;

type
  TFrmEditor = class(TForm)
    Azioni: TActionList;
    ActNuovo: TAction;
    ActApri: TAction;
    ActSalva: TAction;
    ActSalvaCome: TAction;
    ActChiudi: TAction;
    ActEsci: TAction;
    ActAnnulla: TAction;
    ActRipeti: TAction;
    ActTrova: TAction;
    ActSostituisci: TAction;
    ActCompila: TAction;
    MainMenu: TMainMenu;
    PC: TPageControl;
    PnlMessaggi: TPanel;
    LstMessaggi: TListBox;
    Divisore: TSplitter;
    BarraStato: TStatusBar;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    FindDialog: TFindDialog;
    ReplaceDialog: TReplaceDialog;
    procedure ActAnnullaExecute(Sender: TObject);
    procedure ActApriExecute(Sender: TObject);
    procedure ActChiudiExecute(Sender: TObject);
    procedure ActCompilaExecute(Sender: TObject);
    procedure ActEsciExecute(Sender: TObject);
    procedure ActNuovoExecute(Sender: TObject);
    procedure ActRipetiExecute(Sender: TObject);
    procedure ActSalvaComeExecute(Sender: TObject);
    procedure ActSalvaExecute(Sender: TObject);
    procedure ActSostituisciExecute(Sender: TObject);
    procedure ActTrovaExecute(Sender: TObject);
    procedure DocumentoUpdate(Sender: TObject);
    procedure FindDialogFind(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject;
                             var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure LstMessaggiDblClick(Sender: TObject);
    procedure PCChange(Sender: TObject);
    procedure ReplaceDialogReplace(Sender: TObject);
  private
    FMessaggi: TMessaggi;
    function Corrente: TDocumento;
    function NuovoDocumento: TDocumento;
    function ChiudiDocumento(D: TDocumento): Boolean;
    procedure AggiornaStato(Sender: TObject);
    procedure Cerca(Dialogo: TFindDialog;
                    Sostituisci: Boolean);
  end;

var
  FrmEditor: TFrmEditor;

implementation

{$R *.lfm}

procedure TFrmEditor.FormCreate(Sender: TObject);
begin
  PnlMessaggi.Align := alBottom;
  PnlMessaggi.Height := 120;
  Divisore.Align := alBottom;
  PC.Align := alClient;
  LstMessaggi.Align := alClient;
  OpenDialog.Filter :=
    'Sorgenti|*.pas;*.pp;*.lpr;*.inc|Tutti i file|*';
  SaveDialog.Filter := OpenDialog.Filter;
  NuovoDocumento;
end;

function TFrmEditor.Corrente: TDocumento;
begin
  if PC.ActivePage = nil then
    Result := nil
  else
    Result := TDocumento(PC.ActivePage.Tag);
end;

function TFrmEditor.NuovoDocumento: TDocumento;
begin
  Result := TDocumento.Create(PC);
  Result.OnStato := @AggiornaStato;
  PC.ActivePage := Result.Scheda;
  Result.Editor.SetFocus;
end;

function TFrmEditor.ChiudiDocumento(D: TDocumento): Boolean;
begin
  Result := True;
  if D = nil then
    Exit;
  if D.Modificato then
    case MessageDlg('Salvare ' + D.Titolo + '?',
                    mtConfirmation,
                    [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        begin
          PC.ActivePage := D.Scheda;
          ActSalva.Execute;
          Result := not D.Modificato;
        end;
      mrCancel: Result := False;
    end;
  if Result then
    D.Free;
end;

procedure TFrmEditor.AggiornaStato(Sender: TObject);
var
  D: TDocumento;
begin
  D := Corrente;
  if D = nil then
    BarraStato.SimpleText := ''
  else
    BarraStato.SimpleText := Format('Riga %d, colonna %d  %s',
      [D.Editor.CaretY, D.Editor.CaretX, D.NomeFile]);
end;

procedure TFrmEditor.PCChange(Sender: TObject);
begin
  AggiornaStato(nil);
end;

procedure TFrmEditor.DocumentoUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Corrente <> nil;
end;

procedure TFrmEditor.ActNuovoExecute(Sender: TObject);
begin
  NuovoDocumento;
end;

procedure TFrmEditor.ActApriExecute(Sender: TObject);
var
  D: TDocumento;
begin
  if OpenDialog.Execute then
  begin
    D := Corrente;
    if (D = nil) or (D.NomeFile <> '') or D.Modificato then
      D := NuovoDocumento;
    D.Carica(OpenDialog.FileName);
    AggiornaStato(nil);
  end;
end;

procedure TFrmEditor.ActSalvaExecute(Sender: TObject);
begin
  if Corrente = nil then
    Exit;
  if Corrente.NomeFile = '' then
    ActSalvaCome.Execute
  else
    Corrente.Salva;
  AggiornaStato(nil);
end;

procedure TFrmEditor.ActSalvaComeExecute(Sender: TObject);
begin
  if Corrente = nil then
    Exit;
  SaveDialog.FileName := Corrente.NomeFile;
  if SaveDialog.Execute then
  begin
    Corrente.Salva(SaveDialog.FileName);
    AggiornaStato(nil);
  end;
end;

procedure TFrmEditor.ActChiudiExecute(Sender: TObject);
begin
  ChiudiDocumento(Corrente);
  AggiornaStato(nil);
end;

procedure TFrmEditor.ActEsciExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEditor.FormCloseQuery(Sender: TObject;
                                    var CanClose: Boolean);
var
  I: Integer;
begin
  for I := PC.PageCount - 1 downto 0 do
    if not ChiudiDocumento(TDocumento(PC.Pages[I].Tag)) then
    begin
      CanClose := False;
      Exit;
    end;
end;

procedure TFrmEditor.ActAnnullaExecute(Sender: TObject);
begin
  if Corrente <> nil then
    Corrente.Editor.Undo;
end;

procedure TFrmEditor.ActRipetiExecute(Sender: TObject);
begin
  if Corrente <> nil then
    Corrente.Editor.Redo;
end;

procedure TFrmEditor.Cerca(Dialogo: TFindDialog;
                           Sostituisci: Boolean);
var
  Opz: TSynSearchOptions;
  Sost: String;
begin
  if Corrente = nil then
    Exit;
  Opz := [];
  if frMatchCase in Dialogo.Options then
    Include(Opz, ssoMatchCase);
  if frWholeWord in Dialogo.Options then
    Include(Opz, ssoWholeWord);
  if not (frDown in Dialogo.Options) then
    Include(Opz, ssoBackwards);
  Sost := '';
  if Sostituisci then
  begin
    Include(Opz, ssoReplace);
    Sost := (Dialogo as TReplaceDialog).ReplaceText;
    if frReplaceAll in Dialogo.Options then
      Include(Opz, ssoReplaceAll);
  end;
  if Corrente.Editor.SearchReplace(Dialogo.FindText, Sost,
                                   Opz) = 0 then
    BarraStato.SimpleText := 'Non trovato: ' +
                             Dialogo.FindText;
end;

procedure TFrmEditor.ActTrovaExecute(Sender: TObject);
begin
  if (Corrente <> nil) and
     (Corrente.Editor.SelText <> '') then
    FindDialog.FindText := Corrente.Editor.SelText;
  FindDialog.Execute;
end;

procedure TFrmEditor.FindDialogFind(Sender: TObject);
begin
  Cerca(FindDialog, False);
end;

procedure TFrmEditor.ActSostituisciExecute(Sender: TObject);
begin
  ReplaceDialog.Execute;
end;

procedure TFrmEditor.ReplaceDialogReplace(Sender: TObject);
begin
  Cerca(ReplaceDialog, True);
end;

procedure TFrmEditor.ActCompilaExecute(Sender: TObject);
var
  Output: String;
  M: TMessaggioCompilatore;
  Ok: Boolean;
begin
  if Corrente = nil then
    Exit;
  if Corrente.Modificato or (Corrente.NomeFile = '') then
    ActSalva.Execute;
  if Corrente.NomeFile = '' then
    Exit;
  Screen.Cursor := crHourGlass;
  try
    Ok := Compila(Corrente.NomeFile, Output, FMessaggi);
  finally
    Screen.Cursor := crDefault;
  end;
  LstMessaggi.Clear;
  for M in FMessaggi do
    LstMessaggi.Items.Add(Format('%s(%d,%d) %s: %s',
      [ExtractFileName(M.NomeFile), M.Riga, M.Colonna, M.Tipo,
       M.Testo]));
  if Ok then
    LstMessaggi.Items.Add('Compilazione riuscita.')
  else if Length(FMessaggi) = 0 then
    LstMessaggi.Items.Add(Output);
end;

procedure TFrmEditor.LstMessaggiDblClick(Sender: TObject);
var
  I: Integer;
begin
  I := LstMessaggi.ItemIndex;
  if (I < 0) or (I > High(FMessaggi)) or (Corrente = nil) then
    Exit;
  Corrente.Editor.CaretY := FMessaggi[I].Riga;
  Corrente.Editor.CaretX := FMessaggi[I].Colonna;
  Corrente.Editor.SetFocus;
end;

end.
