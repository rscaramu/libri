program Capitalizza;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function Capitalizza(const S: string): string;
var
  I: Integer;
  Inizio: Boolean;
begin
  Result := LowerCase(S);
  Inizio := True;
  for I := 1 to Length(Result) do
    if Result[I] = ' ' then
      Inizio := True
    else if Inizio then
    begin
      Result[I] := UpCase(Result[I]);
      Inizio := False;
    end;
end;

begin
  WriteLn(Capitalizza('mARIO rossi'));
  WriteLn(Capitalizza('a'), '|', Capitalizza(''), '|');
end.
