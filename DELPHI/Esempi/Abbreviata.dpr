program Abbreviata;

{$APPTYPE CONSOLE}

function Verifica(const Nome: string; V: Boolean): Boolean;
begin
  WriteLn('valuto ', Nome);
  Result := V;
end;

begin
  if Verifica('A', False) and Verifica('B', True) then
    WriteLn('entrambi');
  if Verifica('C', True) or Verifica('D', True) then
    WriteLn('almeno uno');
end.
