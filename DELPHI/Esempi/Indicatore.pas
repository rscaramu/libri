unit Indicatore;

interface

uses
  System.SysUtils, System.Classes, System.Types, Vcl.Controls,
  Vcl.Graphics;

type
  TIndicatore = class(TGraphicControl)
  private
    FValore: Integer;
    FColore: TColor;
    procedure SetValore(const V: Integer);
    procedure SetColore(const V: TColor);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Valore: Integer read FValore write SetValore
      default 0;
    property Colore: TColor read FColore write SetColore
      default clGreen;
    property Align;
    property Anchors;
    property Visible;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Studio', [TIndicatore]);
end;

constructor TIndicatore.Create(AOwner: TComponent);
begin
  inherited;
  Width := 200;
  Height := 24;
  FColore := clGreen;
end;

procedure TIndicatore.SetValore(const V: Integer);
begin
  if V <> FValore then
  begin
    FValore := Max(0, Min(100, V));
    Invalidate;
  end;
end;

procedure TIndicatore.SetColore(const V: TColor);
begin
  if V <> FColore then
  begin
    FColore := V;
    Invalidate;
  end;
end;

procedure TIndicatore.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Color := clGray;
  Canvas.Rectangle(R);
  R.Inflate(-2, -2);
  R.Width := Round(R.Width * FValore / 100);
  Canvas.Brush.Color := FColore;
  Canvas.Pen.Style := psClear;
  Canvas.Rectangle(R.Left, R.Top, R.Right + 1, R.Bottom + 1);
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Color := clBlack;
  var Testo := FValore.ToString + '%';
  Canvas.TextOut((Width - Canvas.TextWidth(Testo)) div 2,
    (Height - Canvas.TextHeight(Testo)) div 2, Testo);
end;

end.
