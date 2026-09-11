{ PerValore - Manuale completo di Free Pascal e Lazarus }
program PerValore;
{$mode objfpc}{$H+}

procedure Raddoppia(N: Integer);
begin
  N := N * 2;
  WriteLn('  dentro: ', N);
end;

var
  X: Integer;
begin
  X := 21;
  Raddoppia(X);
  WriteLn('fuori: ', X);
end.
