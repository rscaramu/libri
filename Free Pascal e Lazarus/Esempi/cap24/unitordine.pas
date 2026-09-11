{ UnitOrdine - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitOrdine;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Dialogs,
  FrameIndirizzo;

type
  TFormOrdine = class(TForm)
    BtnConferma: TButton;
    procedure BtnConfermaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FFatturazione, FSpedizione: TFrmIndirizzo;
  end;

var
  FormOrdine: TFormOrdine;

implementation

{$R *.lfm}

procedure TFormOrdine.FormCreate(Sender: TObject);
begin
  FFatturazione := TFrmIndirizzo.Create(Self);
  FFatturazione.Name := 'FrmFatturazione';
  FFatturazione.Parent := Self;
  FFatturazione.Top := 8;
  FSpedizione := TFrmIndirizzo.Create(Self);
  FSpedizione.Name := 'FrmSpedizione';
  FSpedizione.Parent := Self;
  FSpedizione.Top := FFatturazione.Top +
                     FFatturazione.Height + 8;
end;

procedure TFormOrdine.BtnConfermaClick(Sender: TObject);
begin
  if not (FFatturazione.Valido and FSpedizione.Valido) then
  begin
    ShowMessage('Completate entrambi gli indirizzi');
    Exit;
  end;
  ShowMessage('Fattura a: ' + FFatturazione.Testo +
              LineEnding + 'Spedisci a: ' +
              FSpedizione.Testo);
end;

end.
