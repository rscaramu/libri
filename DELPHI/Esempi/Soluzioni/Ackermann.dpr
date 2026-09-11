program Ackermann;

{$APPTYPE CONSOLE}

function Ack(M, N: Int64): Int64;
begin
  if M = 0 then
    Result := N + 1
  else if N = 0 then
    Result := Ack(M - 1, 1)
  else
    Result := Ack(M - 1, Ack(M, N - 1));
end;

var
  M, N: Integer;
begin
  for M := 0 to 3 do
  begin
    for N := 0 to 3 do
      Write(Ack(M, N):5);
    WriteLn;
  end;
end.
