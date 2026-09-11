{ UnitConferma - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitConferma;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Dialogs;

type
  TFormConferma = class(TForm)
    Memo: TMemo;
    procedure FormCloseQuery(Sender: TObject;
                             var CanClose: Boolean);
    procedure MemoChange(Sender: TObject);
  private
    FModificato: Boolean;
  end;

var
  FormConferma: TFormConferma;

implementation

{$R *.lfm}

procedure TFormConferma.MemoChange(Sender: TObject);
begin
  FModificato := True;
end;

procedure TFormConferma.FormCloseQuery(Sender: TObject;
                                       var CanClose: Boolean);
begin
  if FModificato then
    CanClose := MessageDlg('Modifiche non salvate. Uscire?',
                           mtConfirmation, [mbYes, mbNo], 0)
                = mrYes;
end;

end.
