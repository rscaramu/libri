{ Celsius - Manuale completo di Free Pascal e Lazarus }
program Celsius;
{$mode objfpc}{$H+}
var
  I: Integer;
  C, F: Double;
begin
  WriteLn('Celsius':10, 'Fahrenheit':12);
  for I := 0 to 4 do
  begin
    C := I * 10;
    F := C * 9 / 5 + 32;
    WriteLn(C:10:1, F:12:1);
  end;
end.
