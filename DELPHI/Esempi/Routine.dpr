program Routine;

{$APPTYPE CONSOLE}

procedure Separatore;
begin
  WriteLn('----------');
end;

function Somma(A, B: Integer): Integer;
begin
  Result := A + B;
end;

function SommaFinoA(N: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to N do
    Result := Result + I;
end;

begin
  Separatore;
  WriteLn(Somma(3, 4));
  WriteLn(SommaFinoA(100));
  Separatore;
end.
