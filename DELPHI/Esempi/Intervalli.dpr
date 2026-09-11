program Intervalli;

{$APPTYPE CONSOLE}

uses
  SysUtils, Math;

type
  TIntervallo = record
    Da, A: Integer;
    constructor Create(ADa, AA: Integer);
    function Vuoto: Boolean;
    class operator Multiply(
      const X, Y: TIntervallo): TIntervallo;
    class operator In(V: Integer;
      const I: TIntervallo): Boolean;
    function Testo: string;
  end;

constructor TIntervallo.Create(ADa, AA: Integer);
begin
  Da := ADa;
  A := AA;
end;

function TIntervallo.Vuoto: Boolean;
begin
  Result := Da > A;
end;

class operator TIntervallo.Multiply(
  const X, Y: TIntervallo): TIntervallo;
begin
  Result.Da := Max(X.Da, Y.Da);
  Result.A := Min(X.A, Y.A);
end;

class operator TIntervallo.In(V: Integer;
  const I: TIntervallo): Boolean;
begin
  Result := (V >= I.Da) and (V <= I.A);
end;

function TIntervallo.Testo: string;
begin
  if Vuoto then
    Result := 'vuoto'
  else
    Result := Format('[%d..%d]', [Da, A]);
end;

var
  X, Y: TIntervallo;
begin
  X := TIntervallo.Create(1, 10);
  Y := TIntervallo.Create(5, 20);
  WriteLn((X * Y).Testo);
  WriteLn((X * TIntervallo.Create(15, 20)).Testo);
  WriteLn(7 in X, ' ', 12 in X);
end.
