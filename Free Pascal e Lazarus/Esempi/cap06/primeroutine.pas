{ PrimeRoutine - Manuale completo di Free Pascal e Lazarus }
program PrimeRoutine;
{$mode objfpc}{$H+}

procedure StampaRiga(Carattere: Char; Lunghezza: Integer);
var
  I: Integer;
begin
  for I := 1 to Lunghezza do
    Write(Carattere);
  WriteLn;
end;

function Massimo(A, B: Integer): Integer;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

begin
  StampaRiga('-', 20);
  WriteLn('Massimo: ', Massimo(3, 9));
  WriteLn('Massimo: ', Massimo(Massimo(5, 1), 4));
  StampaRiga('=', 20);
end.
