{ UsaGeometria - Manuale completo di Free Pascal e Lazarus }
program UsaGeometria;
{$mode objfpc}{$H+}
uses
  Geometria;
var
  A, B: TPunto;
begin
  A := Punto(0, 0);
  B := Punto(3, 4);
  WriteLn('Distanza: ', Distanza(A, B):0:1);
  WriteLn('Area: ', AreaCerchio(1):0:4);
  WriteLn('Chiamate registrate: ', Chiamate);
end.
