{ Assaggio10 - Manuale completo di Free Pascal e Lazarus }
program Assaggio10;
{$mode objfpc}{$H+}

function Fattoriale(N: Integer): Int64;
var
  I: Integer;
begin
  Result := 1;
  for I := 2 to N do
    Result := Result * I;
end;

var
  K: Integer;
begin
  for K := 8 to 10 do
    WriteLn('Fattoriale di ', K, ' = ', Fattoriale(K));
end.
