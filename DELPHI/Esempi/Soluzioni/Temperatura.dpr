program Temperatura;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TTemperatura = class
  private
    FKelvin: Double;
    procedure SetKelvin(const V: Double);
    function GetCelsius: Double;
    procedure SetCelsius(const V: Double);
    function GetFahrenheit: Double;
    procedure SetFahrenheit(const V: Double);
  public
    property Kelvin: Double read FKelvin write SetKelvin;
    property Celsius: Double read GetCelsius write SetCelsius;
    property Fahrenheit: Double read GetFahrenheit
      write SetFahrenheit;
  end;

procedure TTemperatura.SetKelvin(const V: Double);
begin
  if V < 0 then
    raise EArgumentException.Create('sotto lo zero assoluto');
  FKelvin := V;
end;

function TTemperatura.GetCelsius: Double;
begin
  Result := FKelvin - 273.15;
end;

procedure TTemperatura.SetCelsius(const V: Double);
begin
  Kelvin := V + 273.15;
end;

function TTemperatura.GetFahrenheit: Double;
begin
  Result := Celsius * 9 / 5 + 32;
end;

procedure TTemperatura.SetFahrenheit(const V: Double);
begin
  Celsius := (V - 32) * 5 / 9;
end;

var
  T: TTemperatura;
begin
  T := TTemperatura.Create;
  try
    T.Celsius := 100;
    WriteLn(T.Kelvin:0:2, ' ', T.Fahrenheit:0:1);
    T.Fahrenheit := 212;
    WriteLn(T.Celsius:0:1);
    try
      T.Celsius := -300;
    except
      on E: EArgumentException do
        WriteLn(E.Message);
    end;
  finally
    T.Free;
  end;
end.
