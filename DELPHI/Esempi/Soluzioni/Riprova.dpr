program Riprova;

{$APPTYPE CONSOLE}

type
  TAzione = reference to function: Boolean;

function Riprova(Tentativi: Integer;
  Azione: TAzione): Boolean;
var
  I: Integer;
begin
  for I := 1 to Tentativi do
    if Azione() then
      Exit(True);
  Result := False;
end;

var
  Chiamate: Integer;
begin
  Chiamate := 0;
  WriteLn(Riprova(5,
    function: Boolean
    begin
      Inc(Chiamate);
      Result := Chiamate = 3;
    end), ' ', Chiamate);
  Chiamate := 0;
  WriteLn(Riprova(2,
    function: Boolean
    begin
      Inc(Chiamate);
      Result := Chiamate = 3;
    end), ' ', Chiamate);
end.
