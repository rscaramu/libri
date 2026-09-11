{ Bisestile - Manuale completo di Free Pascal e Lazarus }
program Bisestile;
{$mode objfpc}{$H+}
const
  Anni: array[1..5] of Integer =
    (1900, 2000, 2024, 2026, 2100);
var
  Anno: Integer;
  B: Boolean;
begin
  for Anno in Anni do
  begin
    B := ((Anno mod 4 = 0) and (Anno mod 100 <> 0))
         or (Anno mod 400 = 0);
    WriteLn(Anno, ': ', B);
  end;
end.
