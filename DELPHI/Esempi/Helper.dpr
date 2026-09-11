program Helper;

{$APPTYPE CONSOLE}

uses
  SysUtils, Math;

type
  TIntegerHelper = record helper for Integer
    function Pari: Boolean;
    function Cifre: Integer;
    function Limitato(Min, Max: Integer): Integer;
  end;

  TDoubleHelper = record helper for Double
    function Arrotondato(Decimali: Integer): Double;
  end;

function TIntegerHelper.Pari: Boolean;
begin
  Result := Self mod 2 = 0;
end;

function TIntegerHelper.Cifre: Integer;
begin
  Result := Length(IntToStr(Abs(Self)));
end;

function TIntegerHelper.Limitato(Min, Max: Integer): Integer;
begin
  if Self < Min then
    Result := Min
  else if Self > Max then
    Result := Max
  else
    Result := Self;
end;

function TDoubleHelper.Arrotondato(Decimali: Integer): Double;
var
  F: Double;
begin
  F := IntPower(10, Decimali);
  Result := Round(Self * F) / F;
end;

var
  N: Integer;
  X: Double;
begin
  N := 12345;
  WriteLn(N.Pari, ' ', N.Cifre, ' ', N.Limitato(0, 100));
  X := 3.14159;
  WriteLn(X.Arrotondato(2):0:4);
end.
