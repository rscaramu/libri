{ Conversioni7 - Manuale completo di Free Pascal e Lazarus }
program Conversioni7;
{$mode objfpc}{$H+}
uses
  SysUtils;
var
  N: Integer;
  D: Double;
  FS: TFormatSettings;
begin
  WriteLn(IntToStr(42) + ' ' + FloatToStr(3.5));
  WriteLn(StrToIntDef('abc', -1), ' ', StrToIntDef('12', -1));
  if TryStrToInt('123x', N) then
    WriteLn('valido')
  else
    WriteLn('non valido');
  FS := DefaultFormatSettings;
  FS.DecimalSeparator := '.';
  D := StrToFloat('2.75', FS);
  WriteLn(D:0:3);
  WriteLn(Format('%d articoli a %.2f euro = %8.2f',
                 [3, D, 3 * D]));
  WriteLn(Format('[%-8s][%8s]', ['sx', 'dx']));
  WriteLn(Format('%x %s %5.1e', [255, BoolToStr(True, True),
                 12345.678]));
  WriteLn(Format('%2:s %1:s %0:s', ['a', 'b', 'c']));
end.
