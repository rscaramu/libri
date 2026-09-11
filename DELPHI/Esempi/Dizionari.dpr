program Dizionari;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Collections;

var
  D: TDictionary<string, Integer>;
  V: Integer;
  Chiavi: TList<string>;
  K: string;
begin
  D := TDictionary<string, Integer>.Create;
  try
    D.Add('mele', 10);
    D.Add('pere', 4);
    D.AddOrSetValue('pere', 5);
    D.AddOrSetValue('uva', 12);
    WriteLn(D.Count, ' ', D['pere']);
    WriteLn(D.ContainsKey('uva'), ' ', D.ContainsKey('kiwi'));
    if D.TryGetValue('mele', V) then
      WriteLn('mele: ', V);
    WriteLn(D.TryGetValue('kiwi', V));
    D['mele'] := 11;
    D.Remove('uva');
    Chiavi := TList<string>.Create(D.Keys);
    try
      Chiavi.Sort;
      for K in Chiavi do
        WriteLn(K, ' = ', D[K]);
    finally
      Chiavi.Free;
    end;
    try
      D.Add('mele', 1);
    except
      on E: EListError do
        WriteLn('chiave duplicata');
    end;
    try
      V := D['kiwi'];
    except
      on E: EListError do
        WriteLn('chiave assente');
    end;
  finally
    D.Free;
  end;
end.
