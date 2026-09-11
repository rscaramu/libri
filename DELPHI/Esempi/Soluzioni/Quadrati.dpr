program Quadrati;

{$APPTYPE CONSOLE}

type
  TF = reference to function: Integer;

function Crea(I: Integer): TF;
begin
  Result := function: Integer
    begin
      Result := I * I;
    end;
end;

var
  Giusti, Sbagliati: array[1..10] of TF;
  I: Integer;
begin
  for I := 1 to 10 do
  begin
    Giusti[I] := Crea(I);
    Sbagliati[I] := function: Integer
      begin
        Result := I * I;
      end;
  end;
  for I := 1 to 10 do
    Write(Giusti[I](), ' ');
  WriteLn;
  WriteLn(Sbagliati[1]() = Sbagliati[10]());
end.
