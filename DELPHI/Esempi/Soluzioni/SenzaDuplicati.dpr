program SenzaDuplicati;

{$APPTYPE CONSOLE}

uses
  Generics.Collections;

function Unici(L: TList<Integer>): TList<Integer>;
var
  Visti: TDictionary<Integer, Boolean>;
  X: Integer;
begin
  Result := TList<Integer>.Create;
  Visti := TDictionary<Integer, Boolean>.Create;
  try
    for X in L do
      if not Visti.ContainsKey(X) then
      begin
        Visti.Add(X, True);
        Result.Add(X);
      end;
  finally
    Visti.Free;
  end;
end;

var
  L, U: TList<Integer>;
  X: Integer;
begin
  L := TList<Integer>.Create;
  L.AddRange([3, 1, 3, 2, 1, 5]);
  U := Unici(L);
  try
    for X in U do
      Write(X, ' ');
    WriteLn;
  finally
    U.Free;
    L.Free;
  end;
end.
