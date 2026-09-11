program ContaPred;

{$APPTYPE CONSOLE}

uses
  SysUtils, Character;

type
  TPredicato = function(C: Char): Boolean;

function Conta(const S: string; Pred: TPredicato): Integer;
var
  C: Char;
begin
  Result := 0;
  for C in S do
    if Pred(C) then
      Inc(Result);
end;

function ECifra(C: Char): Boolean;
begin
  Result := TCharacter.IsDigit(C);
end;

function ESpazio(C: Char): Boolean;
begin
  Result := C = ' ';
end;

begin
  WriteLn(Conta('Via Roma 12, int 3', ECifra), ' ',
    Conta('Via Roma 12, int 3', ESpazio));
end.
