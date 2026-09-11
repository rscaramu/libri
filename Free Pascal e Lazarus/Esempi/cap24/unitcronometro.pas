{ UnitCronometro - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitCronometro;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls;

type
  TFormCronometro = class(TForm)
    LblTempo: TLabel;
    BtnAvvia: TButton;
    BtnFerma: TButton;
    BtnAzzera: TButton;
    Timer: TTimer;
    procedure BtnAvviaClick(Sender: TObject);
    procedure BtnAzzeraClick(Sender: TObject);
    procedure BtnFermaClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FInizio: QWord;
    FAccumulato: QWord;
    procedure Mostra;
  end;

var
  FormCronometro: TFormCronometro;

implementation

{$R *.lfm}

procedure TFormCronometro.Mostra;
var
  Ms: QWord;
begin
  Ms := FAccumulato;
  if Timer.Enabled then
    Ms := Ms + GetTickCount64 - FInizio;
  LblTempo.Caption := Format('%d:%.2d.%d',
    [Ms div 60000, (Ms div 1000) mod 60,
     (Ms div 100) mod 10]);
end;

procedure TFormCronometro.BtnAvviaClick(Sender: TObject);
begin
  FInizio := GetTickCount64;
  Timer.Enabled := True;
end;

procedure TFormCronometro.BtnFermaClick(Sender: TObject);
begin
  if Timer.Enabled then
  begin
    FAccumulato := FAccumulato + GetTickCount64 - FInizio;
    Timer.Enabled := False;
    Mostra;
  end;
end;

procedure TFormCronometro.BtnAzzeraClick(Sender: TObject);
begin
  Timer.Enabled := False;
  FAccumulato := 0;
  Mostra;
end;

procedure TFormCronometro.TimerTimer(Sender: TObject);
begin
  Mostra;
end;

end.
