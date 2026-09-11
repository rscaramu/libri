unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    btnSaluta: TButton;
    edtNome: TEdit;
    lblRisultato: TLabel;
    procedure btnSalutaClick(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnSalutaClick(Sender: TObject);
begin
  if edtNome.Text.Trim = '' then
  begin
    ShowMessage('Inserite un nome');
    edtNome.SetFocus;
    Exit;
  end;
  lblRisultato.Caption := 'Ciao, ' + edtNome.Text.Trim + '!';
end;

end.
