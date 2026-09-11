program Ricorsione;

{$APPTYPE CONSOLE}

function Fibonacci(N: Integer): Int64;
begin
  if N < 2 then
    Result := N
  else
    Result := Fibonacci(N - 1) + Fibonacci(N - 2);
end;

procedure Hanoi(N: Integer; const Da, A, Via: string);
begin
  if N = 0 then
    Exit;
  Hanoi(N - 1, Da, Via, A);
  WriteLn('disco ', N, ' da ', Da, ' a ', A);
  Hanoi(N - 1, Via, A, Da);
end;

begin
  WriteLn(Fibonacci(30));
  Hanoi(3, 'A', 'C', 'B');
end.
