{ FrameRicerca - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit FrameRicerca;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls;

type
  TCercaEvento = procedure(Sender: TObject;
                           const Testo: String) of object;

  TFrmRicerca = class(TFrame)
    EdtTesto: TEdit;
    BtnCerca: TButton;
    procedure BtnCercaClick(Sender: TObject);
    procedure EdtTestoKeyPress(Sender: TObject;
                               var Key: Char);
  private
    FOnCerca: TCercaEvento;
  public
    property OnCerca: TCercaEvento read FOnCerca
                                   write FOnCerca;
  end;

implementation

{$R *.lfm}

procedure TFrmRicerca.BtnCercaClick(Sender: TObject);
begin
  if Assigned(FOnCerca) then
    FOnCerca(Self, Trim(EdtTesto.Text));
end;

procedure TFrmRicerca.EdtTestoKeyPress(Sender: TObject;
                                       var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BtnCercaClick(Sender);
  end;
end;

end.
