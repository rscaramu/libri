program EnumNomi;

{$APPTYPE CONSOLE}

uses
  SysUtils, TypInfo;

type
  TStato = (stBozza, stInviato, stApprovato, stRifiutato);
  TStati = set of TStato;

var
  S: TStato;
  I: Integer;
  Insieme: TStati;
begin
  for S := Low(TStato) to High(TStato) do
    Write(GetEnumName(TypeInfo(TStato), Ord(S)), ' ');
  WriteLn;
  I := GetEnumValue(TypeInfo(TStato), 'stApprovato');
  WriteLn(I, ' ', GetEnumValue(TypeInfo(TStato), 'xyz'));
  S := TStato(I);
  WriteLn(Ord(S));
  Insieme := [stBozza, stRifiutato];
  for S in Insieme do
    Write(GetEnumName(TypeInfo(TStato), Ord(S)), ',');
  WriteLn;
  WriteLn(GetTypeData(TypeInfo(TStato))^.MaxValue);
end.
