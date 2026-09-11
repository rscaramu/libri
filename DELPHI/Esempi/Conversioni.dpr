program Conversioni;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  N: Integer;
  X: Double;
  Ok: Boolean;
begin
  WriteLn(IntToStr(42) + '!', ' ', StrToInt('-17'));
  WriteLn(StrToInt('$FF'), ' ', IntToHex(255, 4));
  WriteLn(StrToIntDef('abc', -1));
  Ok := TryStrToInt('123', N);
  WriteLn(Ok, ' ', N);
  Ok := TryStrToInt('12x', N);
  WriteLn(Ok);
  X := StrToFloat('3.25');
  WriteLn(X:0:2, ' ', FloatToStr(X * 2));
  WriteLn(FloatToStrF(1234.5678, ffFixed, 10, 2));
  WriteLn(BoolToStr(True, True), ' ', StrToBool('1'));
end.
