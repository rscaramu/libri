program NomePulito;

{$APPTYPE CONSOLE}

uses
  SysUtils, TypInfo, Character;

type
  TAllineamento = (alSinistra, alCentro, alDestra);

function NomePulito(TipoInfo: PTypeInfo;
  Valore: Integer): string;
var
  I: Integer;
begin
  Result := GetEnumName(TipoInfo, Valore);
  I := 1;
  while (I <= Length(Result)) and
      TCharacter.IsLower(Result[I]) do
    Inc(I);
  Result := Copy(Result, I, MaxInt);
end;

var
  A: TAllineamento;
begin
  for A := Low(TAllineamento) to High(TAllineamento) do
    Write(NomePulito(TypeInfo(TAllineamento), Ord(A)), ' ');
  WriteLn;
end.
