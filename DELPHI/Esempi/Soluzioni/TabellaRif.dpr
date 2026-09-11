program TabellaRif;

{$APPTYPE CONSOLE}

type
  TFunzione = reference to function(X: Integer): Integer;

procedure Tabella(F: TFunzione; Da, A: Integer);
var
  X: Integer;
begin
  for X := Da to A do
    WriteLn(X, ' -> ', F(X));
end;

var
  Fattore: Integer;
begin
  Fattore := 7;
  Tabella(function(X: Integer): Integer
    begin
      Result := X * Fattore;
    end, 1, 3);
end.
