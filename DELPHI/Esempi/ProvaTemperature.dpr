program ProvaTemperature;

{$APPTYPE CONSOLE}

uses
  Temperature;

begin
  WriteLn(CelsiusToFahrenheit(100):0:1);
  WriteLn(FahrenheitToCelsius(98.6):0:1);
end.
