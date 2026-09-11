program HelperStringa;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TMioHelper = record helper for string
    function Inverti: string;
    function ContaVocali: Integer;
  end;

function TMioHelper.Inverti: string;
var
  I: Integer;
begin
  Result := '';
  for I := Length(Self) downto 1 do
    Result := Result + Self[I];
end;

function TMioHelper.ContaVocali: Integer;
var
  C: Char;
begin
  Result := 0;
  for C in Self do
    if CharInSet(C, ['a', 'e', 'i', 'o', 'u']) then
      Inc(Result);
end;

var
  S: string;
begin
  S := 'delphi';
  WriteLn(S.Inverti, ' ', S.ContaVocali);
end.
