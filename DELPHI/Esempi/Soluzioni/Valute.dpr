program Valute;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TEuro = record
    Valore: Currency;
    class operator Implicit(V: Currency): TEuro;
    class operator Implicit(const E: TEuro): string;
  end;
  TDollaro = record
    Valore: Currency;
    class operator Implicit(V: Currency): TDollaro;
    class operator Implicit(const D: TDollaro): string;
  end;

class operator TEuro.Implicit(V: Currency): TEuro;
begin
  Result.Valore := V;
end;

class operator TEuro.Implicit(const E: TEuro): string;
begin
  Result := FormatCurr('0.00 EUR', E.Valore);
end;

class operator TDollaro.Implicit(V: Currency): TDollaro;
begin
  Result.Valore := V;
end;

class operator TDollaro.Implicit(const D: TDollaro): string;
begin
  Result := FormatCurr('0.00 USD', D.Valore);
end;

var
  E: TEuro;
  D: TDollaro;
  S: string;
begin
  E := 10;
  D := 12.5;
  S := E; WriteLn(S);
  S := D; WriteLn(S);
  // E := D;  non compila: Incompatible types
end.
