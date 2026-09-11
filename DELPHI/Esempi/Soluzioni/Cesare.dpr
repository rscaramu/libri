program Cesare;

{$APPTYPE CONSOLE}

function Cesare(const S: string; K: Integer): string;
var
  I: Integer;
  C: Char;
  Base: Integer;
begin
  Result := S;
  K := ((K mod 26) + 26) mod 26;
  for I := 1 to Length(Result) do
  begin
    C := Result[I];
    if (C >= 'a') and (C <= 'z') then
      Base := Ord('a')
    else if (C >= 'A') and (C <= 'Z') then
      Base := Ord('A')
    else
      Continue;
    Result[I] := Chr(Base + (Ord(C) - Base + K) mod 26);
  end;
end;

const
  T = 'Ave, Caesar!';
begin
  WriteLn(Cesare(T, 3));
  WriteLn(Cesare(Cesare(T, 3), -3) = T);
end.
