program NomiEnum;

{$APPTYPE CONSOLE}

uses
  SysUtils, TypInfo;

type
  TColore = (Rosso, Verde, Blu);

function NomiEnumerazione(TI: PTypeInfo): TArray<string>;
var
  I: Integer;
begin
  Result := nil;
  for I := GetTypeData(TI)^.MinValue to
      GetTypeData(TI)^.MaxValue do
    Result := Result + [GetEnumName(TI, I)];
end;

begin
  WriteLn(string.Join(',',
    NomiEnumerazione(TypeInfo(TColore))));
end.
