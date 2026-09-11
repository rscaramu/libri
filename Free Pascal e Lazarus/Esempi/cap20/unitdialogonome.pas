{ UnitDialogoNome - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitDialogoNome;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls;

type
  TDialogoNome = class(TForm)
    EdtNome: TEdit;
    BtnOk: TButton;
    BtnAnnulla: TButton;
    procedure FormCloseQuery(Sender: TObject;
                             var CanClose: Boolean);
  public
    class function Chiedi(var Nome: String): Boolean;
  end;

implementation

{$R *.lfm}

procedure TDialogoNome.FormCloseQuery(Sender: TObject;
                                      var CanClose: Boolean);
begin
  if (ModalResult = mrOk) and (Trim(EdtNome.Text) = '') then
  begin
    EdtNome.SetFocus;
    CanClose := False;
  end;
end;

class function TDialogoNome.Chiedi(var Nome: String): Boolean;
var
  D: TDialogoNome;
begin
  D := TDialogoNome.Create(nil);
  try
    D.EdtNome.Text := Nome;
    Result := D.ShowModal = mrOk;
    if Result then
      Nome := Trim(D.EdtNome.Text);
  finally
    D.Free;
  end;
end;

end.
