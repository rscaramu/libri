{ Assaggio - Manuale completo di Free Pascal e Lazarus }
program Assaggio;
{$mode objfpc}{$H+}
uses
  SysUtils;

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
  for K := 0 to 5 do
    WriteLn('Fattoriale di ', K, ' = ', Fattoriale(K));
  WriteLn('Compilato il ', {$I %DATE%});
end.
