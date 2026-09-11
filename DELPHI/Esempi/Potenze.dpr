program Potenze;

{$APPTYPE CONSOLE}

uses
  Math;

begin
  WriteLn(Sqr(5), ' ', Sqrt(2):0:6);
  WriteLn(Power(2, 10):0:0, ' ', Power(2, 0.5):0:6);
  WriteLn(Max(3, 8), ' ', Min(3, 8));
  WriteLn(Abs(-4), ' ', Abs(-4.5):0:1);
end.
