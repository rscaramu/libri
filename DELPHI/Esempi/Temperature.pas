unit Temperature;

interface

function CelsiusToFahrenheit(C: Double): Double;
function FahrenheitToCelsius(F: Double): Double;

implementation

function CelsiusToFahrenheit(C: Double): Double;
begin
  Result := C * 9 / 5 + 32;
end;

function FahrenheitToCelsius(F: Double): Double;
begin
  Result := (F - 32) * 5 / 9;
end;

end.
