{ Pitagorica - Manuale completo di Free Pascal e Lazarus }
program Pitagorica;
{$mode objfpc}{$H+}
var
  R, C: Integer;
begin
  for R := 1 to 5 do
  begin
    for C := 1 to 5 do
      Write(R * C:4);
    WriteLn;
  end;
end.
