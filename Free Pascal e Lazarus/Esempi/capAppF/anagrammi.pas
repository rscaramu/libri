{ Anagrammi - Manuale completo di Free Pascal e Lazarus }
program Anagrammi;
{$mode objfpc}{$H+}
uses
  SysUtils;
type
  TCaratteri = set of Char;

function Caratteri(const S: String): TCaratteri;
var
  C: Char;
begin
  Result := [];
  for C in LowerCase(S) do
    Include(Result, C);
end;

var
  A, B: String;
begin
  A := 'roma';
  B := 'amor';
  WriteLn('Stessi caratteri: ', Caratteri(A) = Caratteri(B));
  WriteLn('Stessi caratteri: ',
          Caratteri('aab') = Caratteri('abb'));
end.
