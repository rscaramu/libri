{ Aritmetica - Manuale completo di Free Pascal e Lazarus }
unit Aritmetica;
{$mode objfpc}{$H+}

interface

function EPrimo(N: Integer): Boolean;
function MCD(A, B: Integer): Integer;
function Fattoriale(N: Integer): Int64;

implementation

function EPrimo(N: Integer): Boolean;
var
  D: Integer;
begin
  if N < 2 then
    Exit(False);
  D := 2;
  while D * D <= N do
  begin
    if N mod D = 0 then
      Exit(False);
    Inc(D);
  end;
  Result := True;
end;

function MCD(A, B: Integer): Integer;
begin
  if B = 0 then Result := A else Result := MCD(B, A mod B);
end;

function Fattoriale(N: Integer): Int64;
begin
  if N <= 1 then
    Result := 1
  else
    Result := N * Fattoriale(N - 1);
end;

end.
