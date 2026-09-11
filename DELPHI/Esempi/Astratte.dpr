program Astratte;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TForma = class abstract
  public
    function Area: Double; virtual; abstract;
    function Nome: string; virtual; abstract;
    function Descrivi: string;
  end;

  TQuadrato = class(TForma)
  private
    FLato: Double;
  public
    constructor Create(ALato: Double);
    function Area: Double; override;
    function Nome: string; override;
  end;

  TCerchio = class(TForma)
  private
    FRaggio: Double;
  public
    constructor Create(ARaggio: Double);
    function Area: Double; override;
    function Nome: string; override;
  end;

function TForma.Descrivi: string;
begin
  Result := Nome + ' di area ' +
    FloatToStrF(Area, ffFixed, 8, 2);
end;

constructor TQuadrato.Create(ALato: Double);
begin
  inherited Create;
  FLato := ALato;
end;

function TQuadrato.Area: Double;
begin
  Result := FLato * FLato;
end;

function TQuadrato.Nome: string;
begin
  Result := 'quadrato';
end;

constructor TCerchio.Create(ARaggio: Double);
begin
  inherited Create;
  FRaggio := ARaggio;
end;

function TCerchio.Area: Double;
begin
  Result := Pi * FRaggio * FRaggio;
end;

function TCerchio.Nome: string;
begin
  Result := 'cerchio';
end;

var
  Forme: array of TForma;
  F: TForma;
begin
  Forme := [TQuadrato.Create(2), TCerchio.Create(1)];
  try
    for F in Forme do
      WriteLn(F.Descrivi);
  finally
    for F in Forme do
      F.Free;
  end;
end.
