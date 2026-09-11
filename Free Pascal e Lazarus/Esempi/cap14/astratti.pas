{ Astratti - Manuale completo di Free Pascal e Lazarus }
program Astratti;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TForma = class
  public
    function Area: Double; virtual; abstract;
    function Perimetro: Double; virtual; abstract;
    function Riassunto: String;
  end;

  TRettangolo = class(TForma)
  private
    FB, FH: Double;
  public
    constructor Create(B, H: Double);
    function Area: Double; override;
    function Perimetro: Double; override;
  end;

  TQuadrato = class(TRettangolo)
  public
    constructor Create(L: Double);
  end;

function TForma.Riassunto: String;
begin
  Result := Format('%s: area %.1f, perimetro %.1f',
                   [ClassName, Area, Perimetro]);
end;

constructor TRettangolo.Create(B, H: Double);
begin
  FB := B;
  FH := H;
end;

function TRettangolo.Area: Double;
begin
  Result := FB * FH;
end;

function TRettangolo.Perimetro: Double;
begin
  Result := 2 * (FB + FH);
end;

constructor TQuadrato.Create(L: Double);
begin
  inherited Create(L, L);
end;

var
  Forme: array[0..1] of TForma;
  I: Integer;
begin
  Forme[0] := TRettangolo.Create(3, 4);
  Forme[1] := TQuadrato.Create(5);
  for I := 0 to High(Forme) do
    WriteLn(Forme[I].Riassunto);
  for I := 0 to High(Forme) do
    Forme[I].Free;
end.
