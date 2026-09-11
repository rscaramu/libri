program Radice;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function Radice(X: Double): Double;
begin
  if X < 0 then
    raise EArgumentOutOfRangeException.Create(
      'radice di negativo');
  Result := Sqrt(X);
end;

begin
  WriteLn(Radice(16):0:1);
  try
    WriteLn(Radice(-1):0:1);
  except
    on E: EArgumentOutOfRangeException do
      WriteLn(E.Message);
  end;
end.
