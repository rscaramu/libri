{ Collezioni - Manuale completo di Free Pascal e Lazarus }
program Collezioni;
{$mode objfpc}{$H+}
uses
  SysUtils, Generics.Collections, Generics.Defaults;
type
  TInteri = specialize TList<Integer>;
  TDizionario = specialize TDictionary<String, Integer>;
  TCodaStringhe = specialize TQueue<String>;

function ConfrontaDecrescente(constref A, B: Integer):
  Integer;
begin
  Result := B - A;
end;

var
  L: TInteri;
  D: TDizionario;
  Q: TCodaStringhe;
  I, V: Integer;
  Coppia: specialize TPair<String, Integer>;
begin
  L := TInteri.Create;
  D := TDizionario.Create;
  Q := TCodaStringhe.Create;
  try
    for I in [5, 3, 9, 1] do
      L.Add(I);
    L.Sort;
    for I in L do
      Write(I, ' ');
    WriteLn;
    L.Sort(specialize TComparer<Integer>.Construct(
             @ConfrontaDecrescente));
    for I in L do
      Write(I, ' ');
    WriteLn('  (', L.Count, ' elementi, IndexOf(9) = ',
            L.IndexOf(9), ')');
    L.Remove(9);
    L.Insert(0, 100);
    WriteLn(L[0], ' ', L[1], ' ', L.Count);

    D.Add('mele', 3);
    D.Add('pere', 5);
    D.AddOrSetValue('mele', 4);
    if D.TryGetValue('mele', V) then
      WriteLn('mele: ', V);
    WriteLn('kiwi? ', D.ContainsKey('kiwi'));
    for Coppia in D do
      WriteLn(Coppia.Key, ' -> ', Coppia.Value);

    Q.Enqueue('primo');
    Q.Enqueue('secondo');
    WriteLn(Q.Dequeue, ' ', Q.Peek, ' ', Q.Count);
  finally
    Q.Free;
    D.Free;
    L.Free;
  end;
end.
