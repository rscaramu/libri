program Formattazione;

{$APPTYPE CONSOLE}

uses
  SysUtils;

begin
  WriteLn(Format('%s ha %d anni', ['Anna', 30]));
  WriteLn(Format('[%5d] [%-5d] [%.5d]', [42, 42, 42]));
  WriteLn(Format('%.2f %8.3f %g', [3.14159, 2.5, 1234.5]));
  WriteLn(Format('%x %8.4x', [255, 255]));
  WriteLn(Format('%s%%', ['100']));
  WriteLn(Format('%1:s, %0:s', ['Rossi', 'Mario']));
end.
