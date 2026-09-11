program Indici;

{$APPTYPE CONSOLE}

var
  S: string;
  I: Integer;
begin
  S := 'delphi';
  WriteLn(S[1], ' ', S[Length(S)]);
  S[1] := 'D';
  WriteLn(S);
  for I := Length(S) downto 1 do
    Write(S[I]);
  WriteLn;
  SetLength(S, 3);
  WriteLn(S, ' ', Length(S));
end.
