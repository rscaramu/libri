program UsaGeometria;

{$APPTYPE CONSOLE}

uses
  Geometria;

begin
  WriteLn('Cerchio: ', AreaCerchio(1.5):0:4);
  WriteLn('Rettangolo: ', AreaRettangolo(3, 4):0:1);
end.
