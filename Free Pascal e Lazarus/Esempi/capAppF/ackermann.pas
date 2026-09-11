{ Ackermann - Manuale completo di Free Pascal e Lazarus }
program Ackermann;
{$mode objfpc}{$H+}

function A(M, N: Integer): Integer;
begin
  if M = 0 then
    Result := N + 1
  else if N = 0 then
    Result := A(M - 1, 1)
  else
    Result := A(M - 1, A(M, N - 1));
end;

begin
  WriteLn('A(2,3) = ', A(2, 3));
  WriteLn('A(3,3) = ', A(3, 3));
end.
