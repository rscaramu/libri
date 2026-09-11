{ Reali - Manuale completo di Free Pascal e Lazarus }
program Reali;
{$mode objfpc}{$H+}
var
  S: Single;
  D, E, F: Double;
  C, G, H: Currency;
begin
  S := 0.1;
  D := 0.1;
  C := 0.1;
  WriteLn('Single  : ', S);
  WriteLn('Double  : ', D);
  WriteLn('Currency: ', C:0:4);
  E := 0.2;
  F := 0.3;
  WriteLn('0.1 + 0.2 = 0.3 ? ', D + E = F);
  G := 0.2;
  H := 0.3;
  WriteLn('In Currency: ', C + G = H);
  WriteLn(D:0:2, ' ', D:8:4, ' ', D:0:20);
end.
