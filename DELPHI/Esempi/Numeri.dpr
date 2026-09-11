program Numeri;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  FS: TFormatSettings;
begin
  FS := FormatSettings;
  FS.DecimalSeparator := ',';
  FS.ThousandSeparator := '.';
  WriteLn(FormatFloat('#,##0.00', 1234567.891, FS));
  WriteLn(FormatFloat('0.000', 3.14159, FS));
  WriteLn(FormatFloat('#.##', 2.5, FS), ' ',
    FormatFloat('#.##', 2, FS), ' ',
    FormatFloat('0.00', 2, FS));
  WriteLn(FormatFloat('0.00;(0.00);zero', -5, FS), ' ',
    FormatFloat('0.00;(0.00);zero', 0, FS));
  WriteLn(FormatFloat('00000', 42, FS));
  WriteLn(FormatCurr('#,##0.00 EUR', 1500, FS));
  WriteLn(FloatToStr(0.1, FS), ' ', FloatToStr(1E20, FS), ' ',
    FloatToStr(123456789012345678.0, FS));
  WriteLn(FloatToStrF(1234.5678, ffFixed, 15, 2, FS), ' ',
    FloatToStrF(1234.5678, ffNumber, 15, 1, FS), ' ',
    FloatToStrF(1234.5678, ffExponent, 4, 2, FS));
  WriteLn(StrToFloat('1234,5', FS):0:1);
  WriteLn(IntToStr(255), ' ', IntToHex(255, 2), ' ',
    Format('%.3d', [7]));
end.
