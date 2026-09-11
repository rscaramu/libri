program Arrotondamenti;

{$APPTYPE CONSOLE}

uses
  Math;

var
  X: Double;
begin
  { stdin: 2.5\n }
  ReadLn(X);
  WriteLn('Trunc: ', Trunc(X));
  WriteLn('Round: ', Round(X));
  WriteLn('Ceil:  ', Ceil(X));
  WriteLn('Floor: ', Floor(X));
end.
