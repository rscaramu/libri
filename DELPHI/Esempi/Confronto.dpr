program Confronto;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  IConfrontabile = interface
    ['{B0A1C2D3-E4F5-4678-9ABC-DEF012345678}']
    function ConfrontaCon(
      const Altro: IConfrontabile): Integer;
    function Testo: string;
  end;

  TVersione = class(TInterfacedObject, IConfrontabile)
  private
    FMaggiore, FMinore: Integer;
  public
    constructor Create(AMaggiore, AMinore: Integer);
    function ConfrontaCon(
      const Altro: IConfrontabile): Integer;
    function Testo: string;
  end;

constructor TVersione.Create(AMaggiore, AMinore: Integer);
begin
  inherited Create;
  FMaggiore := AMaggiore;
  FMinore := AMinore;
end;

function TVersione.ConfrontaCon(
  const Altro: IConfrontabile): Integer;
var
  A: TVersione;
begin
  A := Altro as TVersione;
  Result := FMaggiore - A.FMaggiore;
  if Result = 0 then
    Result := FMinore - A.FMinore;
end;

function TVersione.Testo: string;
begin
  Result := Format('%d.%d', [FMaggiore, FMinore]);
end;

function Maggiore(const A, B: IConfrontabile): IConfrontabile;
begin
  if A.ConfrontaCon(B) >= 0 then
    Result := A
  else
    Result := B;
end;

begin
  WriteLn(Maggiore(TVersione.Create(3, 2),
    TVersione.Create(3, 10)).Testo);
  WriteLn(Maggiore(TVersione.Create(4, 0),
    TVersione.Create(3, 99)).Testo);
end.
