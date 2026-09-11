program Valute;

{$APPTYPE CONSOLE}

type
  TEuro = type Currency;
  TDollaro = type Currency;

var
  E: TEuro;
  D: TDollaro;
begin
  E := 100;
  D := E;
  WriteLn(E:0:2, ' ', D:0:2);
end.
