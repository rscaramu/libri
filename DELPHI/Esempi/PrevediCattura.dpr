program PrevediCattura;

{$APPTYPE CONSOLE}

type
  TAzione = reference to procedure;

var
  X: Integer;
  A, B: TAzione;

function Crea(V: Integer): TAzione;
begin
  Result := procedure
    begin
      WriteLn(V + X);
    end;
end;

begin
  X := 10;
  A := Crea(1);
  B := Crea(2);
  X := 100;
  A();
  B();
end.
