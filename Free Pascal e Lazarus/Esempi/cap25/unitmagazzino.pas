{ UnitMagazzino - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitMagazzino;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls,
  Dialogs, Magazzino;

type
  TFormMagazzino = class(TForm)
    Lista: TListView;
    EdtCodice: TEdit;
    EdtQuanti: TEdit;
    BtnCarica: TButton;
    BtnScarica: TButton;
    LblValore: TLabel;
    procedure BtnCaricaClick(Sender: TObject);
    procedure BtnScaricaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FMagazzino: TMagazzino;
    procedure MagazzinoCambiato(Sender: TObject);
    procedure Movimento(Carico: Boolean);
  end;

var
  FormMagazzino: TFormMagazzino;

implementation

{$R *.lfm}

procedure TFormMagazzino.FormCreate(Sender: TObject);
begin
  FMagazzino := TMagazzino.Create;
  FMagazzino.OnCambio := @MagazzinoCambiato;
  Lista.ViewStyle := vsReport;
  Lista.Columns.Add.Caption := 'Codice';
  Lista.Columns.Add.Caption := 'Descrizione';
  Lista.Columns.Add.Caption := 'Giacenza';
  FMagazzino.Aggiungi('V001', 'Vite M4', 0.05);
  FMagazzino.Aggiungi('D001', 'Dado M4', 0.03);
end;

procedure TFormMagazzino.FormDestroy(Sender: TObject);
begin
  FMagazzino.Free;
end;

procedure TFormMagazzino.MagazzinoCambiato(Sender: TObject);
var
  A: TArticolo;
  V: TListItem;
begin
  Lista.BeginUpdate;
  try
    Lista.Clear;
    for A in FMagazzino.Articoli do
    begin
      V := Lista.Items.Add;
      V.Caption := A.Codice;
      V.SubItems.Add(A.Descrizione);
      V.SubItems.Add(IntToStr(A.Giacenza));
    end;
  finally
    Lista.EndUpdate;
  end;
  LblValore.Caption := Format('Valore: %.2f',
                              [FMagazzino.ValoreTotale]);
end;

procedure TFormMagazzino.Movimento(Carico: Boolean);
var
  N: Integer;
begin
  if not TryStrToInt(EdtQuanti.Text, N) then
  begin
    ShowMessage('Quantita'' non valida');
    Exit;
  end;
  try
    if Carico then
      FMagazzino.Carica(EdtCodice.Text, N)
    else
      FMagazzino.Scarica(EdtCodice.Text, N);
  except
    on E: EMagazzino do
      MessageDlg(E.Message, mtWarning, [mbOk], 0);
  end;
end;

procedure TFormMagazzino.BtnCaricaClick(Sender: TObject);
begin
  Movimento(True);
end;

procedure TFormMagazzino.BtnScaricaClick(Sender: TObject);
begin
  Movimento(False);
end;

end.
