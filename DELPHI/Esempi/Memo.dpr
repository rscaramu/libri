program Memo;

{$APPTYPE CONSOLE}

type
  TFunzione = reference to function(N: Integer): Int64;

function Memoizza(F: TFunzione): TFunzione;
var
  Cache: array of Int64;
  Noto: array of Boolean;
begin
  SetLength(Cache, 100);
  SetLength(Noto, 100);
  Result := function(N: Integer): Int64
    begin
      if not Noto[N] then
      begin
        Cache[N] := F(N);
        Noto[N] := True;
      end;
      Result := Cache[N];
    end;
end;

var
  Chiamate: Integer;
  Quadrato, Veloce: TFunzione;
  I: Integer;
  V: Int64;
begin
  Chiamate := 0;
  Quadrato := function(N: Integer): Int64
    begin
      Inc(Chiamate);
      Result := Int64(N) * N;
    end;
  Veloce := Memoizza(Quadrato);
  for I := 1 to 3 do
  begin
    V := Veloce(7);
    WriteLn(V);
  end;
  WriteLn('chiamate reali: ', Chiamate);
end.
