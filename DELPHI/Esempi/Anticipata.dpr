program Anticipata;

{$APPTYPE CONSOLE}

function Pari(N: Integer): Boolean; forward;

function Dispari(N: Integer): Boolean;
begin
  if N = 0 then
    Result := False
  else
    Result := Pari(N - 1);
end;

function Pari(N: Integer): Boolean;
begin
  if N = 0 then
    Result := True
  else
    Result := Dispari(N - 1);
end;

begin
  WriteLn(Pari(10), ' ', Dispari(7));
end.
