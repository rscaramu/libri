program Palindromo;

{$APPTYPE CONSOLE}

uses
  SysUtils, Character;

function Pulisci(const S: string): string;
var
  C: Char;
begin
  Result := '';
  for C in S do
    if TCharacter.IsLetterOrDigit(C) then
      Result := Result + TCharacter.ToLower(C);
end;

function EPalindromo(const S: string): Boolean;
var
  P: string;
  I, L: Integer;
begin
  P := Pulisci(S);
  L := Length(P);
  for I := 1 to L div 2 do
    if P[I] <> P[L - I + 1] then
      Exit(False);
  Result := True;
end;

begin
  WriteLn(EPalindromo('I topi non avevano nipoti'));
  WriteLn(EPalindromo('Delphi'));
  WriteLn(EPalindromo(''));
end.
