program ContaParole;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Collections;

var
  D: TDictionary<string, Integer>;
  Parola: string;
  Chiavi: TList<string>;
  N: Integer;
begin
  D := TDictionary<string, Integer>.Create;
  Chiavi := nil;
  try
    for Parola in
        'il gatto e il cane e il topo'.Split([' ']) do
    begin
      if D.TryGetValue(Parola, N) then
        D[Parola] := N + 1
      else
        D.Add(Parola, 1);
    end;
    Chiavi := TList<string>.Create(D.Keys);
    Chiavi.Sort;
    for Parola in Chiavi do
      WriteLn(Parola, ': ', D[Parola]);
  finally
    Chiavi.Free;
    D.Free;
  end;
end.
