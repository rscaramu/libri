{ VarOutConst - Manuale completo di Free Pascal e Lazarus }
program VarOutConst;
{$mode objfpc}{$H+}

procedure Scambia(var A, B: Integer);
var
  T: Integer;
begin
  T := A;
  A := B;
  B := T;
end;

procedure DivMod(Dividendo, Divisore: Integer;
                 out Quoziente, Resto: Integer);
begin
  Quoziente := Dividendo div Divisore;
  Resto := Dividendo mod Divisore;
end;

function Conta(const S: String; C: Char): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
    if S[I] = C then
      Inc(Result);
end;

var
  X, Y, Q, R: Integer;
begin
  X := 1;
  Y := 2;
  Scambia(X, Y);
  WriteLn('X = ', X, ', Y = ', Y);
  DivMod(17, 5, Q, R);
  WriteLn('17 = 5 * ', Q, ' + ', R);
  WriteLn('a in banana: ', Conta('banana', 'a'));
end.
