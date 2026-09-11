{ UnitCalcolatrice - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitCalcolatrice;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Dialogs;

type
  TFormCalc = class(TForm)
    EdtA: TEdit;
    EdtB: TEdit;
    LblRisultato: TLabel;
    BtnSomma: TButton;
    BtnDiff: TButton;
    BtnProd: TButton;
    BtnDiv: TButton;
    procedure OperazioneClick(Sender: TObject);
  end;

var
  FormCalc: TFormCalc;

implementation

{$R *.lfm}

procedure TFormCalc.OperazioneClick(Sender: TObject);
var
  A, B, R: Double;
  Op: String;
begin
  if not TryStrToFloat(EdtA.Text, A) or
     not TryStrToFloat(EdtB.Text, B) then
  begin
    ShowMessage('Inserite due numeri');
    Exit;
  end;
  Op := (Sender as TButton).Caption;
  case Op of
    '+': R := A + B;
    '-': R := A - B;
    '*': R := A * B;
    '/': if B = 0 then
         begin
           ShowMessage('Divisione per zero');
           Exit;
         end
         else
           R := A / B;
  else
    Exit;
  end;
  LblRisultato.Caption := Format('%g %s %g = %g',
                                 [A, Op, B, R]);
end;

end.
