program Conversioni;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TMetri = record
    Valore: Double;
    class operator Implicit(V: Double): TMetri;
    class operator Implicit(const M: TMetri): string;
    class operator Explicit(const M: TMetri): Double;
    class operator Add(const A, B: TMetri): TMetri;
    class operator LessThan(const A, B: TMetri): Boolean;
    class operator GreaterThan(const A, B: TMetri): Boolean;
  end;

class operator TMetri.Implicit(V: Double): TMetri;
begin
  Result.Valore := V;
end;

class operator TMetri.Implicit(const M: TMetri): string;
begin
  Result := Format('%g m', [M.Valore]);
end;

class operator TMetri.Explicit(const M: TMetri): Double;
begin
  Result := M.Valore;
end;

class operator TMetri.Add(const A, B: TMetri): TMetri;
begin
  Result.Valore := A.Valore + B.Valore;
end;

class operator TMetri.LessThan(const A, B: TMetri): Boolean;
begin
  Result := A.Valore < B.Valore;
end;

class operator TMetri.GreaterThan(
  const A, B: TMetri): Boolean;
begin
  Result := A.Valore > B.Valore;
end;

procedure Stampa(const S: string);
begin
  WriteLn(S);
end;

var
  A, B: TMetri;
  D: Double;
begin
  A := 12.5;
  B := 7;
  Stampa(A + B);
  D := Double(A);
  WriteLn(D:0:1, ' ', A > B);
end.
