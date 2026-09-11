program Liste;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Collections;

var
  L: TList<string>;
  S: string;
begin
  L := TList<string>.Create;
  try
    L.Add('pera');
    L.Add('mela');
    L.AddRange(['uva', 'kiwi']);
    L.Insert(0, 'fico');
    WriteLn(L.Count, ' ', L[0], ' ', L.First, ' ', L.Last);
    WriteLn(L.IndexOf('uva'), ' ', L.IndexOf('ananas'), ' ',
      L.Contains('mela'));
    L.Delete(0);
    L.Remove('uva');
    for S in L do
      Write(S, ' ');
    WriteLn;
    L.Sort;
    for S in L do
      Write(S, ' ');
    WriteLn;
    L.Reverse;
    WriteLn(L[0]);
    L.Exchange(0, 2);
    WriteLn(L[0], ' ', L[2]);
    L.Clear;
    WriteLn(L.Count);
  finally
    L.Free;
  end;
end.
