program Misure2;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Collections;

var
  S: string;
  SB: TStringBuilder;
  L: TList<string>;
  D: TDictionary<string, Integer>;
  I, Trovati: Integer;
  T0, T1, T2: Int64;
begin
  T0 := GetTickCount64;
  S := '';
  for I := 1 to 50000 do
    S := S + 'x';
  T1 := GetTickCount64 - T0;
  T0 := GetTickCount64;
  SB := TStringBuilder.Create;
  try
    for I := 1 to 50000 do
      SB.Append('x');
    S := SB.ToString;
  finally
    SB.Free;
  end;
  T2 := GetTickCount64 - T0;
  WriteLn(Length(S), ' ', T2 <= T1 + 5);
  L := TList<string>.Create;
  D := TDictionary<string, Integer>.Create;
  try
    for I := 1 to 10000 do
    begin
      L.Add('k' + IntToStr(I));
      D.Add('k' + IntToStr(I), I);
    end;
    T0 := GetTickCount64;
    Trovati := 0;
    for I := 1 to 10000 do
      if L.IndexOf('k' + IntToStr(I)) >= 0 then
        Inc(Trovati);
    T1 := GetTickCount64 - T0;
    T0 := GetTickCount64;
    for I := 1 to 10000 do
      if D.ContainsKey('k' + IntToStr(I)) then
        Inc(Trovati);
    T2 := GetTickCount64 - T0;
    WriteLn(Trovati, ' ', T2 < T1);
  finally
    D.Free;
    L.Free;
  end;
end.
