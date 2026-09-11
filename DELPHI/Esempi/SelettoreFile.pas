unit SelettoreFile;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls,
  Vcl.Dialogs, Vcl.ExtCtrls;

type
  TSelettoreFile = class(TCustomPanel)
  private
    FEdit: TEdit;
    FPulsante: TButton;
    FFiltro: string;
    procedure PulsanteClick(Sender: TObject);
    function GetNomeFile: string;
    procedure SetNomeFile(const V: string);
  protected
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property NomeFile: string read GetNomeFile
      write SetNomeFile;
    property Filtro: string read FFiltro write FFiltro;
    property Align;
    property Anchors;
    property Enabled;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Studio', [TSelettoreFile]);
end;

constructor TSelettoreFile.Create(AOwner: TComponent);
begin
  inherited;
  BevelOuter := bvNone;
  Width := 300;
  Height := 25;
  FEdit := TEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.SetSubComponent(True);
  FPulsante := TButton.Create(Self);
  FPulsante.Parent := Self;
  FPulsante.SetSubComponent(True);
  FPulsante.Caption := '...';
  FPulsante.OnClick := PulsanteClick;
  FFiltro := 'Tutti i file (*.*)|*.*';
  Resize;
end;

procedure TSelettoreFile.Resize;
begin
  inherited;
  if FPulsante = nil then
    Exit;
  FPulsante.SetBounds(Width - 28, 0, 28, Height);
  FEdit.SetBounds(0, 0, Width - 32, Height);
end;

procedure TSelettoreFile.PulsanteClick(Sender: TObject);
var
  D: TOpenDialog;
begin
  D := TOpenDialog.Create(Self);
  try
    D.Filter := FFiltro;
    D.FileName := FEdit.Text;
    if D.Execute then
      FEdit.Text := D.FileName;
  finally
    D.Free;
  end;
end;

function TSelettoreFile.GetNomeFile: string;
begin
  Result := FEdit.Text;
end;

procedure TSelettoreFile.SetNomeFile(const V: string);
begin
  FEdit.Text := V;
end;

end.
