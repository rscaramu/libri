unit UnitContatore;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormContatore = class(TForm)
    lblValore: TLabel;
    btnPiu: TButton;
    btnMeno: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnPiuClick(Sender: TObject);
    procedure btnMenoClick(Sender: TObject);
  private
    FValore: Integer;
    procedure Aggiorna;
  end;

var
  FormContatore: TFormContatore;

implementation

{$R *.dfm}

procedure TFormContatore.FormCreate(Sender: TObject);
begin
  FValore := 0;
  Aggiorna;
end;

procedure TFormContatore.Aggiorna;
begin
  lblValore.Caption := FValore.ToString;
  btnMeno.Enabled := FValore > 0;
end;

procedure TFormContatore.btnPiuClick(Sender: TObject);
begin
  Inc(FValore);
  Aggiorna;
end;

procedure TFormContatore.btnMenoClick(Sender: TObject);
begin
  Dec(FValore);
  Aggiorna;
end;

end.
