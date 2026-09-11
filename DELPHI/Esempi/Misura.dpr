program Misura;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Generics.Collections;

const
  N = 100000;
var
  SL: TStringList;
  L: TList<string>;
  I: Integer;
  T0: Int64;
  MsOrdinata, MsAllaFine: Int64;
begin
  SL := TStringList.Create;
  L := TList<string>.Create;
  try
    T0 := GetTickCount64;
    SL.Sorted := True;
    for I := 1 to N do
      SL.Add('riga ' + IntToStr((I * 7919) mod N));
    MsOrdinata := GetTickCount64 - T0;
    T0 := GetTickCount64;
    for I := 1 to N do
      L.Add('riga ' + IntToStr((I * 7919) mod N));
    L.Sort;
    MsAllaFine := GetTickCount64 - T0;
    WriteLn(SL.Count = L.Count);
    WriteLn(SL[0] = L[0]);
    WriteLn(MsAllaFine <= MsOrdinata);
  finally
    SL.Free;
    L.Free;
  end;
end.
