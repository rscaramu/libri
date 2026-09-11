program Bolli;

{$APPTYPE CONSOLE}

type
  TVeicolo = class
    function BolloAnnuale: Currency; virtual; abstract;
  end;
  TAuto = class(TVeicolo)
    function BolloAnnuale: Currency; override;
  end;
  TCamion = class(TVeicolo)
    function BolloAnnuale: Currency; override;
  end;
  TMoto = class(TVeicolo)
    function BolloAnnuale: Currency; override;
  end;

function TAuto.BolloAnnuale: Currency;
begin
  Result := 250;
end;

function TCamion.BolloAnnuale: Currency;
begin
  Result := 900;
end;

function TMoto.BolloAnnuale: Currency;
begin
  Result := 60;
end;

var
  V: array[0..2] of TVeicolo;
  X: TVeicolo;
  Tot: Currency;
begin
  V[0] := TAuto.Create;
  V[1] := TCamion.Create;
  V[2] := TMoto.Create;
  Tot := 0;
  for X in V do
    Tot := Tot + X.BolloAnnuale;
  WriteLn(Tot:0:2);
  for X in V do
    X.Free;
end.
