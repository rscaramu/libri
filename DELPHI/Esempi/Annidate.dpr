program Annidate;

{$APPTYPE CONSOLE}

function ContaVocali(const S: string): Integer;

  function EVocale(C: Char): Boolean;
  begin
    Result := C in ['a', 'e', 'i', 'o', 'u'];
  end;

var
  C: Char;
begin
  Result := 0;
  for C in S do
    if EVocale(C) then
      Inc(Result);
end;

begin
  WriteLn(ContaVocali('programmazione'));
end.
