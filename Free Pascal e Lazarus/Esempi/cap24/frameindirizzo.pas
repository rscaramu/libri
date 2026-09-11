{ FrameIndirizzo - Manuale completo di Free Pascal e Lazarus }
{ Unit LCL: va inserita in un progetto Lazarus e richiede il file .lfm del form }
unit FrameIndirizzo;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls;

type
  TFrmIndirizzo = class(TFrame)
    EdtVia: TEdit;
    EdtCitta: TEdit;
    EdtCap: TEdit;
    LblVia: TLabel;
    LblCitta: TLabel;
    LblCap: TLabel;
    procedure EdtCapKeyPress(Sender: TObject; var Key: Char);
  private
    function GetTesto: String;
    procedure SetTesto(const V: String);
  public
    function Valido: Boolean;
    property Testo: String read GetTesto write SetTesto;
  end;

implementation

{$R *.lfm}

procedure TFrmIndirizzo.EdtCapKeyPress(Sender: TObject;
                                       var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

function TFrmIndirizzo.GetTesto: String;
begin
  Result := Format('%s, %s %s',
    [EdtVia.Text, EdtCap.Text, EdtCitta.Text]);
end;

procedure TFrmIndirizzo.SetTesto(const V: String);
begin
  EdtVia.Text := V;
end;

function TFrmIndirizzo.Valido: Boolean;
begin
  Result := (Trim(EdtVia.Text) <> '') and
            (Length(EdtCap.Text) = 5) and
            (Trim(EdtCitta.Text) <> '');
end;

end.
