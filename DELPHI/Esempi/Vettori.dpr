program Vettori;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TVettore = record
    X, Y: Double;
    constructor Create(AX, AY: Double);
    class operator Add(const A, B: TVettore): TVettore;
    class operator Subtract(const A, B: TVettore): TVettore;
    class operator Multiply(const A: TVettore;
      K: Double): TVettore;
    class operator Multiply(K: Double;
      const A: TVettore): TVettore;
    class operator Negative(const A: TVettore): TVettore;
    class operator Equal(const A, B: TVettore): Boolean;
    class operator NotEqual(const A, B: TVettore): Boolean;
    function Modulo: Double;
    function Testo: string;
  end;

constructor TVettore.Create(AX, AY: Double);
begin
  X := AX;
  Y := AY;
end;

class operator TVettore.Add(const A, B: TVettore): TVettore;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

class operator TVettore.Subtract(
  const A, B: TVettore): TVettore;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

class operator TVettore.Multiply(const A: TVettore;
  K: Double): TVettore;
begin
  Result.X := A.X * K;
  Result.Y := A.Y * K;
end;

class operator TVettore.Multiply(K: Double;
  const A: TVettore): TVettore;
begin
  Result := A * K;
end;

class operator TVettore.Negative(
  const A: TVettore): TVettore;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
end;

class operator TVettore.Equal(const A, B: TVettore): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y);
end;

class operator TVettore.NotEqual(
  const A, B: TVettore): Boolean;
begin
  Result := not (A = B);
end;

function TVettore.Modulo: Double;
begin
  Result := Sqrt(X * X + Y * Y);
end;

function TVettore.Testo: string;
begin
  Result := Format('(%g, %g)', [X, Y]);
end;

var
  A, B, C: TVettore;
begin
  A := TVettore.Create(3, 4);
  B := TVettore.Create(1, 1);
  C := A + B;
  WriteLn(C.Testo);
  WriteLn((A - B).Testo, ' ', (A * 2).Testo, ' ',
    (2 * A).Testo);
  WriteLn((-A).Testo, ' ', A.Modulo:0:1);
  WriteLn(A = B, ' ', A <> B, ' ', A = TVettore.Create(3, 4));
end.
