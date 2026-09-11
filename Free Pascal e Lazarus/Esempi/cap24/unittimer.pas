{ UnitTimer - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit UnitTimer;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls;

type
  TFormTimer = class(TForm)
    LblOra: TLabel;
    LblStato: TLabel;
    Memo: TMemo;
    TimerOra: TTimer;
    TimerSalva: TIdleTimer;
    procedure MemoChange(Sender: TObject);
    procedure TimerOraTimer(Sender: TObject);
    procedure TimerSalvaTimer(Sender: TObject);
  end;

var
  FormTimer: TFormTimer;

implementation

{$R *.lfm}

procedure TFormTimer.TimerOraTimer(Sender: TObject);
begin
  LblOra.Caption := FormatDateTime('hh:nn:ss', Now);
end;

procedure TFormTimer.MemoChange(Sender: TObject);
begin
  LblStato.Caption := 'Modificato...';
  TimerSalva.Enabled := False;   { riparte da zero }
  TimerSalva.Enabled := True;
end;

procedure TFormTimer.TimerSalvaTimer(Sender: TObject);
begin
  TimerSalva.Enabled := False;
  Memo.Lines.SaveToFile('bozza.txt');
  LblStato.Caption := 'Salvato alle ' +
                      FormatDateTime('hh:nn:ss', Now);
end;

end.
