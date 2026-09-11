{ Testo - Manuale completo di Free Pascal e Lazarus }
unit Testo;
{$mode objfpc}{$H+}

interface

function Capitalizza(const S: String): String;
function ContaParole(const S: String): Integer;

implementation

uses
  SysUtils;

function Capitalizza(const S: String): String;
begin
  if S = '' then
    Exit('');
  Result := UpperCase(S[1]) +
            LowerCase(Copy(S, 2, Length(S)));
end;

function ContaParole(const S: String): Integer;
var
  I: Integer;
  InParola: Boolean;
begin
  Result := 0;
  InParola := False;
  for I := 1 to Length(S) do
    if S[I] in [' ', #9, #10, #13] then
      InParola := False
    else if not InParola then
    begin
      InParola := True;
      Inc(Result);
    end;
end;

end.
