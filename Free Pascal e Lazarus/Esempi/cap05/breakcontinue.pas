{ BreakContinue - Manuale completo di Free Pascal e Lazarus }
program BreakContinue;
{$mode objfpc}{$H+}

function PrimoDivisore(N: Integer): Integer;
var
  D: Integer;
begin
  for D := 2 to N - 1 do
    if N mod D = 0 then
      Exit(D);
  Result := N;    { nessun divisore: N e' primo }
end;

var
  I: Integer;
begin
  for I := 1 to 20 do
  begin
    if I mod 2 = 0 then
      Continue;             { salta i pari }
    if I > 13 then
      Break;                { esce al primo dispari > 13 }
    Write(I, ' ');
  end;
  WriteLn;
  WriteLn('Primo divisore di 91: ', PrimoDivisore(91));
  WriteLn('Primo divisore di 97: ', PrimoDivisore(97));
end.
