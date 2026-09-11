{ CostoEccezioni - Manuale completo di Free Pascal e Lazarus }
program CostoEccezioni;
{$mode objfpc}{$H+}
uses
  SysUtils;
var
  I, N: Integer;
  T1, T2: QWord;
begin
  T1 := GetTickCount64;
  for I := 1 to 100000 do
    try
      N := StrToInt('abc');
    except
      N := 0;
    end;
  T1 := GetTickCount64 - T1;
  T2 := GetTickCount64;
  for I := 1 to 100000 do
    if not TryStrToInt('abc', N) then
      N := 0;
  T2 := GetTickCount64 - T2;
  WriteLn('Le eccezioni costano di piu''? ', T1 > T2 * 5);
end.
