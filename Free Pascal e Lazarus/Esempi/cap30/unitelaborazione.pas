{ UnitElaborazione - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitElaborazione;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls;

type
  TLavoro = class(TThread)
  private
    FPercentuale: Integer;
    FMessaggio: String;
    FBarra: TProgressBar;
    FEtichetta: TLabel;
    procedure Aggiorna;
  protected
    procedure Execute; override;
  public
    constructor Create(ABarra: TProgressBar;
                       AEtichetta: TLabel);
  end;

  TFormElaborazione = class(TForm)
    BtnAvvia: TButton;
    BtnFerma: TButton;
    Barra: TProgressBar;
    LblStato: TLabel;
    procedure BtnAvviaClick(Sender: TObject);
    procedure BtnFermaClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject;
                             var CanClose: Boolean);
  private
    FLavoro: TLavoro;
    procedure LavoroTerminato(Sender: TObject);
  end;

var
  FormElaborazione: TFormElaborazione;

implementation

{$R *.lfm}

constructor TLavoro.Create(ABarra: TProgressBar;
                           AEtichetta: TLabel);
begin
  inherited Create(True);
  FBarra := ABarra;
  FEtichetta := AEtichetta;
  FreeOnTerminate := True;
end;

procedure TLavoro.Execute;
var
  I: Integer;
begin
  for I := 1 to 100 do
  begin
    if Terminated then
    begin
      FMessaggio := 'Interrotto';
      Synchronize(@Aggiorna);
      Exit;
    end;
    Sleep(50);                       { lavoro simulato }
    FPercentuale := I;
    FMessaggio := Format('Elaborazione: %d%%', [I]);
    Synchronize(@Aggiorna);
  end;
  FMessaggio := 'Completato';
  Synchronize(@Aggiorna);
end;

procedure TLavoro.Aggiorna;
begin
  FBarra.Position := FPercentuale;
  FEtichetta.Caption := FMessaggio;
end;

procedure TFormElaborazione.BtnAvviaClick(Sender: TObject);
begin
  if Assigned(FLavoro) then
    Exit;
  FLavoro := TLavoro.Create(Barra, LblStato);
  FLavoro.OnTerminate := @LavoroTerminato;
  BtnAvvia.Enabled := False;
  BtnFerma.Enabled := True;
  FLavoro.Start;
end;

procedure TFormElaborazione.BtnFermaClick(Sender: TObject);
begin
  if Assigned(FLavoro) then
    FLavoro.Terminate;
end;

procedure TFormElaborazione.LavoroTerminato(Sender: TObject);
begin
  FLavoro := nil;               { FreeOnTerminate lo libera }
  BtnAvvia.Enabled := True;
  BtnFerma.Enabled := False;
end;

procedure TFormElaborazione.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if Assigned(FLavoro) then
  begin
    FLavoro.Terminate;
    CanClose := False;               { riprovare dopo }
    LblStato.Caption := 'Attendere la fine...';
  end;
end;

end.
