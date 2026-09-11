program RimuoviPari;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Collections;

var
  L: TList<Integer>;
  I: Integer;
begin
  L := TList<Integer>.Create;
  try
    L.AddRange([1, 2, 3, 4, 5, 6, 7, 8]);
    for I := L.Count - 1 downto 0 do
      if L[I] mod 2 = 0 then
        L.Delete(I);
    for I in L do
      Write(I, ' ');
    WriteLn;
  finally
    L.Free;
  end;
end.
