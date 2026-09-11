{ Conversioni - Manuale completo di Free Pascal e Lazarus }
program Conversioni;
{$mode objfpc}{$H+}
uses
  SysUtils, Math;
var
  D: Double;
  N: Integer;
  S: String;
begin
  D := 7.6;
  WriteLn('Trunc: ', Trunc(D), '  Round: ', Round(D));
  WriteLn('Floor: ', Floor(D), '  Ceil: ', Ceil(D));
  WriteLn('Round(2.5) = ', Round(2.5),
          '  Round(3.5) = ', Round(3.5));
  N := 300;
  WriteLn('Byte(300) = ', Byte(N));
  S := IntToStr(N) + ' euro';
  WriteLn(S);
  N := StrToInt('42') * 2;
  WriteLn(N);
  D := StrToFloat('3.5') + 1;
  WriteLn(D:0:1);
end.
