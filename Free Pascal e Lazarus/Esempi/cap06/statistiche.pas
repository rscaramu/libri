{ Statistiche - Manuale completo di Free Pascal e Lazarus }
program Statistiche;
{$mode objfpc}{$H+}
uses
  Math;

procedure Stat(A, B, C: Double;
               out Minimo, Massimo, Media: Double);
begin
  Minimo := Min(A, Min(B, C));
  Massimo := Max(A, Max(B, C));
  Media := (A + B + C) / 3;
end;

var
  Mn, Mx, Md: Double;
begin
  Stat(4.5, 2.0, 9.5, Mn, Mx, Md);
  WriteLn('Min = ', Mn:0:2, '  Max = ', Mx:0:2,
          '  Media = ', Md:0:2);
end.
