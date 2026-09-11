unit UnitPrincipale;

interface

uses
  System.SysUtils, System.Types, System.UITypes,
  System.Classes, System.Variants, FMX.Types, FMX.Controls,
  FMX.Forms,
  FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.Edit,
  FMX.Controls.Presentation;

type
  TFormPrincipale = class(TForm)
    edtNome: TEdit;
    btnSaluta: TButton;
    lblRisultato: TLabel;
    procedure btnSalutaClick(Sender: TObject);
  end;

var
  FormPrincipale: TFormPrincipale;

implementation

{$R *.fmx}

procedure TFormPrincipale.btnSalutaClick(Sender: TObject);
begin
  lblRisultato.Text := 'Ciao, ' + edtNome.Text.Trim + '!';
end;

end.
