{ Primi - Manuale completo di Free Pascal e Lazarus }
program Primi;
{$mode objfpc}{$H+}

function EPrimo(N: Integer): Boolean;
var
  D: Integer;
begin
  if N < 2 then
    Exit(False);
  D := 2;
  while D * D <= N do
  begin
    if N mod D = 0 then
      Exit(False);
    Inc(D);
  end;
  Result := True;
end;

var
  I: Integer;
begin
  for I := 1 to 50 do
    if EPrimo(I) then
      Write(I, ' ');
  WriteLn;
end.
