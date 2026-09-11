unit Geometria;

interface

function AreaCerchio(Raggio: Double): Double;
function AreaRettangolo(Base, Altezza: Double): Double;

implementation

const
  PiGreco = 3.14159265358979;

function AreaCerchio(Raggio: Double): Double;
begin
  Result := PiGreco * Raggio * Raggio;
end;

function AreaRettangolo(Base, Altezza: Double): Double;
begin
  Result := Base * Altezza;
end;

end.
