{ Operatori - Manuale completo di Free Pascal e Lazarus }
program Operatori;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TVettore = record
    X, Y: Double;
  end;

operator + (const A, B: TVettore) R: TVettore;
begin
  R.X := A.X + B.X;
  R.Y := A.Y + B.Y;
end;

operator - (const A, B: TVettore) R: TVettore;
begin
  R.X := A.X - B.X;
  R.Y := A.Y - B.Y;
end;

operator * (const A: TVettore; K: Double) R: TVettore;
begin
  R.X := A.X * K;
  R.Y := A.Y * K;
end;

operator * (const A, B: TVettore) R: Double;  { scalare }
begin
  R := A.X * B.X + A.Y * B.Y;
end;

operator = (const A, B: TVettore) R: Boolean;
begin
  R := (A.X = B.X) and (A.Y = B.Y);
end;

operator := (const S: String) R: TVettore;   { da 'x,y' }
var
  P: Integer;
begin
  P := Pos(',', S);
  R.X := StrToFloat(Copy(S, 1, P - 1));
  R.Y := StrToFloat(Copy(S, P + 1, Length(S)));
end;

function Str(const V: TVettore): String;
begin
  Result := Format('(%.1f, %.1f)', [V.X, V.Y]);
end;

var
  A, B, C: TVettore;
begin
  A := '1,2';
  B := '3,4';
  C := A + B;
  WriteLn('A + B = ', Str(C));
  WriteLn('B - A = ', Str(B - A));
  WriteLn('A * 3 = ', Str(A * 3));
  WriteLn('A . B = ', (A * B):0:1);
  WriteLn('A = A? ', A = A, ', A = B? ', A = B);
end.
