program Iniziali;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function Iniziali(const Nome: string): string;
var
  Parola: string;
begin
  Result := '';
  for Parola in Nome.Split([' '],
      TStringSplitOptions.ExcludeEmpty) do
    Result := Result + UpCase(Parola[1]) + '.';
end;

begin
  WriteLn(Iniziali('mario rossi'));
  WriteLn(Iniziali('  anna  maria   verdi '));
end.
