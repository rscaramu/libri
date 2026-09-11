{ UnitDinamica - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitDinamica;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls;

type
  TFormDinamica = class(TForm)
    BtnAggiungi: TButton;
    Pannello: TPanel;
    procedure BtnAggiungiClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FQuanti: Integer;
    procedure PulsanteClick(Sender: TObject);
  end;

var
  FormDinamica: TFormDinamica;

implementation

{$R *.lfm}

procedure TFormDinamica.FormCreate(Sender: TObject);
begin
  FQuanti := 0;
end;

procedure TFormDinamica.BtnAggiungiClick(Sender: TObject);
var
  B: TButton;
begin
  Inc(FQuanti);
  B := TButton.Create(Self);      { Owner: il form }
  B.Parent := Pannello;           { Parent: il pannello }
  B.Left := 8;
  B.Top := 8 + (FQuanti - 1) * 32;
  B.Width := 120;
  B.Caption := 'Pulsante ' + IntToStr(FQuanti);
  B.Tag := FQuanti;
  B.OnClick := @PulsanteClick;
end;

procedure TFormDinamica.PulsanteClick(Sender: TObject);
begin
  Caption := Format('Premuto il pulsante %d',
                    [(Sender as TButton).Tag]);
end;

end.
