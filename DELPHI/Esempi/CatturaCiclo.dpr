program CatturaCiclo;

{$APPTYPE CONSOLE}

type
  TAzione = reference to procedure;

var
  Azioni: array of TAzione;
  I: Integer;
  A: TAzione;

procedure Aggiungi(Valore: Integer);
begin
  Azioni := Azioni + [procedure
    begin
      Write(Valore, ' ');
    end];
end;

begin
  SetLength(Azioni, 3);
  for I := 0 to 2 do
    Azioni[I] := procedure
      begin
        Write(I, ' ');
      end;
  for A in Azioni do
    A();
  WriteLn;
  Azioni := nil;
  for I := 0 to 2 do
    Aggiungi(I);
  for A in Azioni do
    A();
  WriteLn;
end.
