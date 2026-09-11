{ Lettura - Manuale completo di Free Pascal e Lazarus }
program Lettura;
{$mode objfpc}{$H+}
var
  A, B: Integer;
begin
  A := 7;
  B := A * 2 + 1;
  WriteLn('A vale ', A, ' e B vale ', B);
end.
