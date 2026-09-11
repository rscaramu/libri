{ UnitFiltro - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitFiltro;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, FrameRicerca;

type
  TFormFiltro = class(TForm)
    Lista: TListBox;
    procedure FormCreate(Sender: TObject);
  private
    FTutti: TStringList;
    FRicerca: TFrmRicerca;
    procedure Cerca(Sender: TObject; const Testo: String);
  public
    destructor Destroy; override;
  end;

var
  FormFiltro: TFormFiltro;

implementation

{$R *.lfm}

procedure TFormFiltro.FormCreate(Sender: TObject);
begin
  FTutti := TStringList.Create;
  FTutti.CommaText := 'Ada,Alan,Grace,Linus,Niklaus';
  FRicerca := TFrmRicerca.Create(Self);
  FRicerca.Name := 'FrmRicerca';
  FRicerca.Parent := Self;
  FRicerca.Align := alTop;
  FRicerca.OnCerca := @Cerca;
  Lista.Align := alClient;
  Cerca(nil, '');
end;

destructor TFormFiltro.Destroy;
begin
  FTutti.Free;
  inherited;
end;

procedure TFormFiltro.Cerca(Sender: TObject;
                            const Testo: String);
var
  S: String;
begin
  Lista.Items.BeginUpdate;
  try
    Lista.Clear;
    for S in FTutti do
      if (Testo = '') or
         (Pos(LowerCase(Testo), LowerCase(S)) > 0) then
        Lista.Items.Add(S);
  finally
    Lista.Items.EndUpdate;
  end;
end;

end.
