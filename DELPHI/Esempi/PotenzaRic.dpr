program PotenzaRic;

{$APPTYPE CONSOLE}

function Potenza(Base: Double; Esp: Integer): Double;
var
  Meta: Double;
begin
  if Esp = 0 then
    Exit(1);
  if Esp < 0 then
    Exit(1 / Potenza(Base, -Esp));
  Meta := Potenza(Base, Esp div 2);
  if Esp mod 2 = 0 then
    Result := Meta * Meta
  else
    Result := Meta * Meta * Base;
end;

begin
  WriteLn(Potenza(2, 10):0:0);
  WriteLn(Potenza(3, 5):0:0);
  WriteLn(Potenza(2, -2):0:2);
end.
