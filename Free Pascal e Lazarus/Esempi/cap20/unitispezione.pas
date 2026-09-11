{ UnitIspezione - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitIspezione;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls;

type
  TFormIspezione = class(TForm)
    BtnElenca: TButton;
    Memo: TMemo;
    EdtProva: TEdit;
    procedure BtnElencaClick(Sender: TObject);
  end;

var
  FormIspezione: TFormIspezione;

implementation

{$R *.lfm}

procedure TFormIspezione.BtnElencaClick(Sender: TObject);
var
  I: Integer;
  C: TComponent;
  Riga: String;
begin
  Memo.Clear;
  for I := 0 to ComponentCount - 1 do
  begin
    C := Components[I];
    Riga := Format('%-12s %-10s', [C.Name, C.ClassName]);
    if C is TControl then
      with TControl(C) do
        Riga := Riga + Format(' (%d, %d) %dx%d',
                              [Left, Top, Width, Height]);
    Memo.Lines.Add(Riga);
  end;
end;

end.
