{ UnitContatore - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitContatore;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type
  TFormContatore = class(TForm)
    BtnConta: TButton;
    BtnAzzera: TButton;
    LblValore: TLabel;
    procedure BtnAzzeraClick(Sender: TObject);
    procedure BtnContaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FClic: Integer;
    procedure Aggiorna;
  public
  end;

var
  FormContatore: TFormContatore;

implementation

{$R *.lfm}

procedure TFormContatore.FormCreate(Sender: TObject);
begin
  FClic := 0;
  Aggiorna;
end;

procedure TFormContatore.BtnContaClick(Sender: TObject);
begin
  Inc(FClic);
  Aggiorna;
end;

procedure TFormContatore.BtnAzzeraClick(Sender: TObject);
begin
  FClic := 0;
  Aggiorna;
end;

procedure TFormContatore.Aggiorna;
begin
  LblValore.Caption := Format('Clic: %d', [FClic]);
  BtnAzzera.Enabled := FClic > 0;
end;

end.
