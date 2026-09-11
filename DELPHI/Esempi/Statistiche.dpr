program Statistiche;

{$APPTYPE CONSOLE}

type
  TStat = record
    Min, Max, Media: Double;
  end;

function Calcola(const A: array of Double): TStat;
var
  X, Somma: Double;
begin
  Result.Min := A[0];
  Result.Max := A[0];
  Somma := 0;
  for X in A do
  begin
    if X < Result.Min then Result.Min := X;
    if X > Result.Max then Result.Max := X;
    Somma := Somma + X;
  end;
  Result.Media := Somma / Length(A);
end;

var
  S: TStat;
begin
  S := Calcola([4.5, 2.0, 8.25, 6.0]);
  WriteLn(S.Min:0:2, ' ', S.Max:0:2, ' ', S.Media:0:2);
end.
