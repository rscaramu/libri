{ Confrontabili - Manuale completo di Free Pascal e Lazarus }
program Confrontabili;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  IConfrontabile = interface
    ['{7F1A2B3C-0003-4000-8000-000000000003}']
    function Confronta(Altro: IConfrontabile): Integer;
    function Testo: String;
  end;

  TVersione = class(TInterfacedObject, IConfrontabile)
  private
    FMaj, FMin, FPatch: Integer;
  public
    constructor Create(AMaj, AMin, APatch: Integer);
    function Confronta(Altro: IConfrontabile): Integer;
    function Testo: String;
  end;

constructor TVersione.Create(AMaj, AMin, APatch: Integer);
begin
  FMaj := AMaj;
  FMin := AMin;
  FPatch := APatch;
end;

function TVersione.Confronta(Altro: IConfrontabile): Integer;
var
  V: TVersione;
begin
  V := Altro as TVersione;
  Result := FMaj - V.FMaj;
  if Result = 0 then
    Result := FMin - V.FMin;
  if Result = 0 then
    Result := FPatch - V.FPatch;
end;

function TVersione.Testo: String;
begin
  Result := Format('%d.%d.%d', [FMaj, FMin, FPatch]);
end;

function Massimo(A, B: IConfrontabile): IConfrontabile;
begin
  if A.Confronta(B) >= 0 then
    Result := A
  else
    Result := B;
end;

var
  V1, V2: IConfrontabile;
begin
  V1 := TVersione.Create(3, 2, 2);
  V2 := TVersione.Create(3, 3, 0);
  WriteLn('Massimo: ', Massimo(V1, V2).Testo);
  WriteLn('V1 vs V2: ', V1.Confronta(V2));
end.
