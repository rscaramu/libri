program Complessi;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TComplesso = record
    Re, Im: Double;
    constructor Create(ARe, AIm: Double);
    class operator Add(const A, B: TComplesso): TComplesso;
    class operator Subtract(
      const A, B: TComplesso): TComplesso;
    class operator Multiply(
      const A, B: TComplesso): TComplesso;
    class operator Equal(const A, B: TComplesso): Boolean;
    class operator NotEqual(const A, B: TComplesso): Boolean;
    class operator Implicit(const C: TComplesso): string;
    function Modulo: Double;
  end;

constructor TComplesso.Create(ARe, AIm: Double);
begin
  Re := ARe; Im := AIm;
end;

class operator TComplesso.Add(
  const A, B: TComplesso): TComplesso;
begin
  Result := TComplesso.Create(A.Re + B.Re, A.Im + B.Im);
end;

class operator TComplesso.Subtract(
  const A, B: TComplesso): TComplesso;
begin
  Result := TComplesso.Create(A.Re - B.Re, A.Im - B.Im);
end;

class operator TComplesso.Multiply(
  const A, B: TComplesso): TComplesso;
begin
  Result := TComplesso.Create(A.Re * B.Re - A.Im * B.Im,
    A.Re * B.Im + A.Im * B.Re);
end;

class operator TComplesso.Equal(
  const A, B: TComplesso): Boolean;
begin
  Result := (A.Re = B.Re) and (A.Im = B.Im);
end;

class operator TComplesso.NotEqual(
  const A, B: TComplesso): Boolean;
begin
  Result := not (A = B);
end;

class operator TComplesso.Implicit(
  const C: TComplesso): string;
begin
  if C.Im >= 0 then
    Result := Format('%g+%gi', [C.Re, C.Im])
  else
    Result := Format('%g%gi', [C.Re, C.Im]);
end;

function TComplesso.Modulo: Double;
begin
  Result := Sqrt(Re * Re + Im * Im);
end;

var
  A, B: TComplesso;
  S: string;
begin
  A := TComplesso.Create(1, 2);
  B := TComplesso.Create(3, -1);
  S := A + B; WriteLn(S);
  S := A * B; WriteLn(S);
  S := A - B; WriteLn(S);
  WriteLn(A.Modulo:0:3, ' ', A = B, ' ', A <> B);
end.
