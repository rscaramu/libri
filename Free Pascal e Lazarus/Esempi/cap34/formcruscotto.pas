{ FormCruscotto - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit FormCruscotto;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls,
  ExtCtrls, Dialogs, fpjson, ApiClient;

type
  TOperazione = (opElenca, opAggiungi, opCompleta);

  TChiamataApi = class(TThread)
  private
    FClient: TApiClient;
    FOperazione: TOperazione;
    FParametro: String;
    FRisultato: TJSONData;
    FErrore: String;
    FOnFine: TNotifyEvent;
    procedure Fine;
  protected
    procedure Execute; override;
  public
    constructor Create(AClient: TApiClient; AOp: TOperazione;
                       const AParam: String;
                       AOnFine: TNotifyEvent);
    property Risultato: TJSONData read FRisultato;
    property Errore: String read FErrore;
    property Operazione: TOperazione read FOperazione;
  end;

  TFrmCruscotto = class(TForm)
    Lista: TListView;
    EdtNuova: TEdit;
    BtnAggiungi: TButton;
    BtnCompleta: TButton;
    BtnAggiorna: TButton;
    BarraStato: TStatusBar;
    TimerAggiorna: TTimer;
    procedure BtnAggiornaClick(Sender: TObject);
    procedure BtnAggiungiClick(Sender: TObject);
    procedure BtnCompletaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerAggiornaTimer(Sender: TObject);
  private
    FClient: TApiClient;
    FInCorso: Integer;
    procedure Avvia(Op: TOperazione; const Param: String);
    procedure ChiamataFinita(Sender: TObject);
    procedure MostraElenco(A: TJSONArray);
  end;

var
  FrmCruscotto: TFrmCruscotto;

implementation

{$R *.lfm}

constructor TChiamataApi.Create(AClient: TApiClient;
  AOp: TOperazione; const AParam: String;
  AOnFine: TNotifyEvent);
begin
  inherited Create(True);
  FClient := AClient;
  FOperazione := AOp;
  FParametro := AParam;
  FOnFine := AOnFine;
  FreeOnTerminate := True;
end;

procedure TChiamataApi.Execute;
var
  Corpo: TJSONObject;
begin
  try
    case FOperazione of
      opElenca:
        FRisultato := FClient.Get('/attivita');
      opAggiungi:
        begin
          Corpo := TJSONObject.Create(['titolo', FParametro]);
          try
            FRisultato := FClient.Post('/attivita', Corpo);
          finally
            Corpo.Free;
          end;
        end;
      opCompleta:
        FRisultato := FClient.Put('/attivita/' + FParametro +
                                  '/completa', nil);
    end;
  except
    on E: Exception do
      FErrore := E.Message;
  end;
  Synchronize(@Fine);
end;

procedure TChiamataApi.Fine;
begin
  if Assigned(FOnFine) then
    FOnFine(Self);
  FRisultato.Free;
end;

procedure TFrmCruscotto.FormCreate(Sender: TObject);
begin
  FClient := TApiClient.Create('http://127.0.0.1:8097/');
  FClient.Token := 'segreto';
  Lista.ViewStyle := vsReport;
  Lista.Columns.Add.Caption := 'Id';
  Lista.Columns.Add.Caption := 'Titolo';
  Lista.Columns.Add.Caption := 'Stato';
  Lista.Columns[1].Width := 250;
  Lista.RowSelect := True;
  TimerAggiorna.Interval := 30000;
  Avvia(opElenca, '');
end;

procedure TFrmCruscotto.FormDestroy(Sender: TObject);
begin
  FClient.Free;
end;

procedure TFrmCruscotto.Avvia(Op: TOperazione;
                              const Param: String);
begin
  Inc(FInCorso);
  BarraStato.SimpleText := 'Comunicazione con il server...';
  TChiamataApi.Create(FClient, Op, Param,
                      @ChiamataFinita).Start;
end;

procedure TFrmCruscotto.ChiamataFinita(Sender: TObject);
var
  C: TChiamataApi;
begin
  Dec(FInCorso);
  C := Sender as TChiamataApi;
  if C.Errore <> '' then
  begin
    BarraStato.SimpleText := 'Errore: ' + C.Errore;
    Exit;
  end;
  BarraStato.SimpleText := 'Aggiornato alle ' +
                           FormatDateTime('hh:nn:ss', Now);
  case C.Operazione of
    opElenca:
      if C.Risultato is TJSONArray then
        MostraElenco(TJSONArray(C.Risultato));
    opAggiungi, opCompleta:
      Avvia(opElenca, '');
  end;
end;

procedure TFrmCruscotto.MostraElenco(A: TJSONArray);
var
  I: Integer;
  O: TJSONObject;
  V: TListItem;
begin
  Lista.BeginUpdate;
  try
    Lista.Clear;
    for I := 0 to A.Count - 1 do
    begin
      O := A.Objects[I];
      V := Lista.Items.Add;
      V.Caption := IntToStr(O.Get('id', 0));
      V.SubItems.Add(O.Get('titolo', ''));
      if O.Get('completata', False) then
        V.SubItems.Add('completata')
      else
        V.SubItems.Add('aperta');
    end;
  finally
    Lista.EndUpdate;
  end;
end;

procedure TFrmCruscotto.BtnAggiornaClick(Sender: TObject);
begin
  Avvia(opElenca, '');
end;

procedure TFrmCruscotto.TimerAggiornaTimer(Sender: TObject);
begin
  if FInCorso = 0 then
    Avvia(opElenca, '');
end;

procedure TFrmCruscotto.BtnAggiungiClick(Sender: TObject);
begin
  if Trim(EdtNuova.Text) = '' then
    Exit;
  Avvia(opAggiungi, Trim(EdtNuova.Text));
  EdtNuova.Clear;
end;

procedure TFrmCruscotto.BtnCompletaClick(Sender: TObject);
begin
  if Lista.Selected <> nil then
    Avvia(opCompleta, Lista.Selected.Caption);
end;

end.
