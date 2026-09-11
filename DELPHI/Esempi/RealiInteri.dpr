program RealiInteri;

{$APPTYPE CONSOLE}

uses
  Math;

begin
  WriteLn(Trunc(3.7), ' ', Trunc(-3.7));
  WriteLn(Round(3.5), ' ', Round(4.5), ' ', Round(5.5));
  WriteLn(Ceil(3.2), ' ', Floor(-3.2));
end.
