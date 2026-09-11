unit EditMisura;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls;

type
  TEditMisura = class(TEdit)
  private
    FDecimali: Integer;
    FUnita: string;
    FOnValoreCambiato: TNotifyEvent;
    function GetValore: Double;
    procedure SetValore(const V: Double);
    procedure SetDecimali(const V: Integer);
  protected
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
    procedure Change; override;
  public
    constructor Create(AOwner: TComponent); override;
    property Valore: Double read GetValore write SetValore;
  published
    property Decimali: Integer read FDecimali
      write SetDecimali default 2;
    property Unita: string read FUnita write FUnita;
    property OnValoreCambiato: TNotifyEvent
      read FOnValoreCambiato write FOnValoreCambiato;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Studio', [TEditMisura]);
end;

constructor TEditMisura.Create(AOwner: TComponent);
begin
  inherited;
  FDecimali := 2;
  Alignment := taRightJustify;
  Text := '';
end;

function TEditMisura.GetValore: Double;
begin
  var T := Text.Replace('.', FormatSettings.DecimalSeparator)
    .Replace(',', FormatSettings.DecimalSeparator);
  if not TryStrToFloat(T, Result) then
    Result := 0;
end;

procedure TEditMisura.SetValore(const V: Double);
begin
  Text := FormatFloat('0.' + StringOfChar('0', FDecimali), V);
end;

procedure TEditMisura.SetDecimali(const V: Integer);
begin
  if (V <> FDecimali) and (V >= 0) and (V <= 6) then
  begin
    FDecimali := V;
    if not (csDesigning in ComponentState) then
      Valore := Valore;
  end;
end;

procedure TEditMisura.KeyPress(var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', ',', '.', '-', #8]) then
    Key := #0;
  inherited;
end;

procedure TEditMisura.DoExit;
begin
  Valore := Valore;
  inherited;
end;

procedure TEditMisura.Change;
begin
  inherited;
  if Assigned(FOnValoreCambiato) then
    FOnValoreCambiato(Self);
end;

end.
