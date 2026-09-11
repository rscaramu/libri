{ Frazioni - Manuale completo di Free Pascal e Lazarus }
program Frazioni;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TFrazione = record
    N, D: Int64;
  end;

function MCD(A, B: Int64): Int64;
begin
  if B = 0 then
    Result := Abs(A)
  else
    Result := MCD(B, A mod B);
end;

function Semplifica(const F: TFrazione): TFrazione;
var
  G: Int64;
begin
  G := MCD(F.N, F.D);
  if G = 0 then
    G := 1;
  Result.N := F.N div G;
  Result.D := F.D div G;
  if Result.D < 0 then
  begin
    Result.N := -Result.N;
    Result.D := -Result.D;
  end;
end;

operator := (V: Integer) R: TFrazione;
begin
  R.N := V;
  R.D := 1;
end;

operator + (const A, B: TFrazione) R: TFrazione;
begin
  R.N := A.N * B.D + B.N * A.D;
  R.D := A.D * B.D;
  R := Semplifica(R);
end;

operator * (const A, B: TFrazione) R: TFrazione;
begin
  R.N := A.N * B.N;
  R.D := A.D * B.D;
  R := Semplifica(R);
end;

operator = (const A, B: TFrazione) R: Boolean;
begin
  R := A.N * B.D = B.N * A.D;
end;

function Fraz(N, D: Int64): TFrazione;
begin
  Result.N := N;
  Result.D := D;
  Result := Semplifica(Result);
end;

function Str(const F: TFrazione): String;
begin
  if F.D = 1 then
    Result := IntToStr(F.N)
  else
    Result := Format('%d/%d', [F.N, F.D]);
end;

var
  A, B: TFrazione;
begin
  A := Fraz(1, 2);
  B := Fraz(1, 3);
  WriteLn(Str(A + B));
  WriteLn(Str(A * B));
  WriteLn(Str(A + A));
  WriteLn(Str(A * 4));
  WriteLn(Fraz(2, 4) = Fraz(1, 2));
end.
