program Asserzioni;

{$APPTYPE CONSOLE}

{$ASSERTIONS ON}

uses
  SysUtils;

function Media(const A: array of Double): Double;
var
  X: Double;
begin
  Assert(Length(A) > 0, 'array vuoto');
  Result := 0;
  for X in A do
    Result := Result + X;
  Result := Result / Length(A);
end;

begin
  WriteLn(Media([1, 2, 3]):0:1);
  try
    WriteLn(Media([]):0:1);
  except
    on E: EAssertionFailed do
      WriteLn('asserzione ', E.ClassName);
  end;
end.
