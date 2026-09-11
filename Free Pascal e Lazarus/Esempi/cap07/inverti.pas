{ Inverti - Manuale completo di Free Pascal e Lazarus }
program Inverti;
{$mode objfpc}{$H+}
type
  TInteri = array of Integer;

procedure InvertiSulPosto(var A: TInteri);
var
  I, J, T: Integer;
begin
  I := 0;
  J := High(A);
  while I < J do
  begin
    T := A[I];
    A[I] := A[J];
    A[J] := T;
    Inc(I);
    Dec(J);
  end;
end;

function EPalindromo(const A: TInteri): Boolean;
var
  I: Integer;
begin
  for I := 0 to High(A) div 2 do
    if A[I] <> A[High(A) - I] then
      Exit(False);
  Result := True;
end;

procedure Stampa(const A: TInteri);
var
  V: Integer;
begin
  for V in A do
    Write(V, ' ');
  WriteLn;
end;

var
  A: TInteri;
begin
  A := [1, 2, 3, 4, 5];
  InvertiSulPosto(A);
  Stampa(A);
  WriteLn(EPalindromo(A), ' ', EPalindromo([1, 2, 1]));
end.
