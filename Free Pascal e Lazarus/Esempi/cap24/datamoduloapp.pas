{ DataModuloApp - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit DataModuloApp;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Controls, ActnList, ExtCtrls;

type
  TDmApp = class(TDataModule)
    Immagini: TImageList;
    AzioniComuni: TActionList;
    ActInfo: TAction;
    TimerSessione: TTimer;
    procedure ActInfoExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure TimerSessioneTimer(Sender: TObject);
  private
    FAvvio: TDateTime;
  public
    function Durata: String;
  end;

var
  DmApp: TDmApp;

implementation

{$R *.lfm}

procedure TDmApp.DataModuleCreate(Sender: TObject);
begin
  FAvvio := Now;
end;

procedure TDmApp.TimerSessioneTimer(Sender: TObject);
begin
  { qui, per esempio, un salvataggio periodico }
end;

function TDmApp.Durata: String;
begin
  Result := FormatDateTime('hh:nn:ss', Now - FAvvio);
end;

procedure TDmApp.ActInfoExecute(Sender: TObject);
begin
  { l'azione e' condivisa da tutti i form }
end;

end.
