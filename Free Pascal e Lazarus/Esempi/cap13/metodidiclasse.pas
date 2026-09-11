{ MetodiDiClasse - Manuale completo di Free Pascal e Lazarus }
program MetodiDiClasse;
{$mode objfpc}{$H+}
type
  TTemperatura = class
  private
    FKelvin: Double;
    class var FCreate: Integer;
  public
    constructor Create(AKelvin: Double);
    class function DaCelsius(C: Double): TTemperatura;
    class function Creati: Integer;
    function Celsius: Double;
  end;

constructor TTemperatura.Create(AKelvin: Double);
begin
  FKelvin := AKelvin;
  Inc(FCreate);
end;

class function TTemperatura.DaCelsius(C: Double):
  TTemperatura;
begin
  Result := TTemperatura.Create(C + 273.15);
end;

class function TTemperatura.Creati: Integer;
begin
  Result := FCreate;
end;

function TTemperatura.Celsius: Double;
begin
  Result := FKelvin - 273.15;
end;

var
  T1, T2: TTemperatura;
begin
  T1 := TTemperatura.Create(300);
  T2 := TTemperatura.DaCelsius(20);
  WriteLn(T1.Celsius:0:2, ' ', T2.Celsius:0:2);
  WriteLn('Creati: ', TTemperatura.Creati);
  T1.Free;
  T2.Free;
end.
