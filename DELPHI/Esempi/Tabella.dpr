program Tabella;

{$APPTYPE CONSOLE}

type
  TFunzione = function(X: Integer): Integer;

function Quadrato(X: Integer): Integer;
begin
  Result := X * X;
end;

function Cubo(X: Integer): Integer;
begin
  Result := X * X * X;
end;

procedure Tabella(F: TFunzione; Da, A: Integer);
var
  X: Integer;
begin
  for X := Da to A do
    WriteLn(X, ' -> ', F(X));
end;

begin
  Tabella(Quadrato, 1, 3);
  Tabella(Cubo, 1, 3);
end.
