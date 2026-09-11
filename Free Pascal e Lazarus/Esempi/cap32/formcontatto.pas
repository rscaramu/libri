{ FormContatto - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit FormContatto;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Dialogs,
  DBCtrls, DataModulo;

type
  TFrmContatto = class(TForm)
    EdtNome: TEdit;
    EdtCognome: TEdit;
    EdtTelefono: TEdit;
    EdtEmail: TEdit;
    CmbGruppo: TDBLookupComboBox;
    BtnOk: TButton;
    BtnAnnulla: TButton;
    LblNome: TLabel;
    LblCognome: TLabel;
    LblTelefono: TLabel;
    LblEmail: TLabel;
    LblGruppo: TLabel;
    procedure FormCloseQuery(Sender: TObject;
                             var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    FId: Integer;
    function Valida(out Messaggio: String): Boolean;
  public
    class function Modifica(var Id: Integer): Boolean;
  end;

implementation

{$R *.lfm}

procedure TFrmContatto.FormCreate(Sender: TObject);
begin
  CmbGruppo.ListSource := DmRubrica.DsGruppi;
  CmbGruppo.KeyField := 'id';
  CmbGruppo.ListField := 'nome';
end;

function TFrmContatto.Valida(out Messaggio: String): Boolean;
begin
  Messaggio := '';
  if Trim(EdtCognome.Text) = '' then
    Messaggio := 'Il cognome e'' obbligatorio'
  else if Trim(EdtNome.Text) = '' then
    Messaggio := 'Il nome e'' obbligatorio'
  else if (EdtEmail.Text <> '') and
          ((Pos('@', EdtEmail.Text) < 2) or
           (Pos('.', EdtEmail.Text) = 0)) then
    Messaggio := 'Email non valida';
  Result := Messaggio = '';
end;

procedure TFrmContatto.FormCloseQuery(Sender: TObject;
                                      var CanClose: Boolean);
var
  Msg: String;
begin
  if ModalResult <> mrOk then
    Exit;
  if not Valida(Msg) then
  begin
    MessageDlg(Msg, mtWarning, [mbOk], 0);
    CanClose := False;
    Exit;
  end;
  FId := DmRubrica.SalvaContatto(FId, Trim(EdtNome.Text),
    Trim(EdtCognome.Text), Trim(EdtTelefono.Text),
    Trim(EdtEmail.Text), StrToIntDef(CmbGruppo.KeyValue, -1));
end;

class function TFrmContatto.Modifica(var Id: Integer):
  Boolean;
var
  F: TFrmContatto;
  N, C, T, E: String;
  G: Integer;
begin
  F := TFrmContatto.Create(nil);
  try
    F.FId := Id;
    if Id = 0 then
      F.Caption := 'Nuovo contatto'
    else
    begin
      F.Caption := 'Modifica contatto';
      if DmRubrica.Leggi(Id, N, C, T, E, G) then
      begin
        F.EdtNome.Text := N;
        F.EdtCognome.Text := C;
        F.EdtTelefono.Text := T;
        F.EdtEmail.Text := E;
        if G > 0 then
          F.CmbGruppo.KeyValue := G;
      end;
    end;
    Result := F.ShowModal = mrOk;
    if Result then
      Id := F.FId;
  finally
    F.Free;
  end;
end;

end.
