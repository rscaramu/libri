program ContaParole;

{$APPTYPE CONSOLE}

function ContaParole(const S: string): Integer;
var
  I: Integer;
  InParola: Boolean;
begin
  Result := 0;
  InParola := False;
  for I := 1 to Length(S) do
    if S[I] = ' ' then
      InParola := False
    else if not InParola then
    begin
      InParola := True;
      Inc(Result);
    end;
end;

begin
  WriteLn(ContaParole('  il gatto   e il  cane '));
  WriteLn(ContaParole(''), ' ', ContaParole('uno'));
end.
