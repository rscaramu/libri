{ Ricorsione - Manuale completo di Free Pascal e Lazarus }
program Ricorsione;
{$mode objfpc}{$H+}

function Fattoriale(N: Integer): Int64;
begin
  if N <= 1 then
    Result := 1
  else
    Result := N * Fattoriale(N - 1);
end;

function MCD(A, B: Integer): Integer;
begin
  if B = 0 then
    Result := A
  else
    Result := MCD(B, A mod B);
end;

procedure Hanoi(N: Integer; Da, A, Via: Char);
begin
  if N = 0 then
    Exit;
  Hanoi(N - 1, Da, Via, A);
  WriteLn('Disco ', N, ': ', Da, ' -> ', A);
  Hanoi(N - 1, Via, A, Da);
end;

begin
  WriteLn('10! = ', Fattoriale(10));
  WriteLn('MCD(84, 36) = ', MCD(84, 36));
  Hanoi(3, 'A', 'C', 'B');
end.
