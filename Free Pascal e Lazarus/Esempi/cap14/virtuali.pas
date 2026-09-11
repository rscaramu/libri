{ Virtuali - Manuale completo di Free Pascal e Lazarus }
program Virtuali;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TFigura = class
  public
    function Nome: String;                  { statico }
    function Area: Double; virtual;         { virtuale }
    function Descrizione: String;
  end;

  TQuadrato = class(TFigura)
  private
    FLato: Double;
  public
    constructor Create(ALato: Double);
    function Nome: String;                  { nasconde }
    function Area: Double; override;        { ridefinisce }
  end;

  TCerchio = class(TFigura)
  private
    FRaggio: Double;
  public
    constructor Create(ARaggio: Double);
    function Area: Double; override;
  end;

function TFigura.Nome: String;
begin
  Result := 'figura generica';
end;

function TFigura.Area: Double;
begin
  Result := 0;
end;

function TFigura.Descrizione: String;
begin
  Result := Nome + ', area ' + Format('%.2f', [Area]);
end;

constructor TQuadrato.Create(ALato: Double);
begin
  FLato := ALato;
end;

function TQuadrato.Nome: String;
begin
  Result := 'quadrato';
end;

function TQuadrato.Area: Double;
begin
  Result := FLato * FLato;
end;

constructor TCerchio.Create(ARaggio: Double);
begin
  FRaggio := ARaggio;
end;

function TCerchio.Area: Double;
begin
  Result := Pi * FRaggio * FRaggio;
end;

var
  F: TFigura;
  Q: TQuadrato;
begin
  Q := TQuadrato.Create(2);
  WriteLn('Q.Nome: ', Q.Nome);
  F := Q;
  WriteLn('F.Nome: ', F.Nome);        { statico: TFigura }
  WriteLn('F.Area: ', F.Area:0:2);    { virtuale: TQuadrato }
  WriteLn(F.Descrizione);
  F.Free;
  F := TCerchio.Create(1);
  WriteLn(F.Descrizione);
  F.Free;
end.
