{ Cerca - Manuale completo di Free Pascal e Lazarus }
program Cerca;
{$mode objfpc}{$H+}

function Cerca(const A: array of Integer;
               V: Integer): Integer;
var
  I: Integer;
begin
  for I := 0 to High(A) do
    if A[I] = V then
      Exit(I);
  Result := -1;
end;

begin
  WriteLn(Cerca([5, 8, 13, 8], 8), ' ', Cerca([5, 8], 9));
end.
