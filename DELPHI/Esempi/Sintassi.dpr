program Sintassi;

{$APPTYPE CONSOLE}

type
  TTrasforma = reference to function(X: Integer): Integer;
  TAzione = reference to procedure;

procedure Applica(const A: array of Integer; F: TTrasforma);
var
  X: Integer;
begin
  for X in A do
    Write(F(X), ' ');
  WriteLn;
end;

procedure Ripeti(N: Integer; A: TAzione);
var
  I: Integer;
begin
  for I := 1 to N do
    A();
end;

var
  Doppio: TTrasforma;
begin
  Doppio := function(X: Integer): Integer
    begin
      Result := X * 2;
    end;
  Applica([1, 2, 3], Doppio);
  Applica([1, 2, 3],
    function(X: Integer): Integer
    begin
      Result := X * X;
    end);
  Ripeti(3,
    procedure
    begin
      Write('.');
    end);
  WriteLn;
end.
