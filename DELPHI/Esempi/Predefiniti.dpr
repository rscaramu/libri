program Predefiniti;

{$APPTYPE CONSOLE}

function Ripeti(const S: string; Volte: Integer = 2;
  const Sep: string = ''): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Volte do
  begin
    if I > 1 then
      Result := Result + Sep;
    Result := Result + S;
  end;
end;

begin
  WriteLn(Ripeti('ab'));
  WriteLn(Ripeti('ab', 3));
  WriteLn(Ripeti('ab', 3, '-'));
end.
