program Date;

{$APPTYPE CONSOLE}

type
  TData = record
    G, M, A: Integer;
    constructor Create(AG, AM, AA: Integer);
    class operator LessThan(const X, Y: TData): Boolean;
    class operator GreaterThan(const X, Y: TData): Boolean;
    class operator Equal(const X, Y: TData): Boolean;
    class operator NotEqual(const X, Y: TData): Boolean;
    function Giorni: Integer;
    function GiorniFino(const Altra: TData): Integer;
  end;

constructor TData.Create(AG, AM, AA: Integer);
begin
  G := AG; M := AM; A := AA;
end;

function TData.Giorni: Integer;
begin
  Result := A * 360 + (M - 1) * 30 + G;
end;

class operator TData.LessThan(const X, Y: TData): Boolean;
begin
  Result := X.Giorni < Y.Giorni;
end;

class operator TData.GreaterThan(const X, Y: TData): Boolean;
begin
  Result := X.Giorni > Y.Giorni;
end;

class operator TData.Equal(const X, Y: TData): Boolean;
begin
  Result := X.Giorni = Y.Giorni;
end;

class operator TData.NotEqual(const X, Y: TData): Boolean;
begin
  Result := not (X = Y);
end;

function TData.GiorniFino(const Altra: TData): Integer;
begin
  Result := Altra.Giorni - Giorni;
end;

var
  X, Y: TData;
begin
  X := TData.Create(15, 3, 2026);
  Y := TData.Create(1, 5, 2026);
  WriteLn(X < Y, ' ', X > Y, ' ', X = Y, ' ',
    X.GiorniFino(Y));
end.
