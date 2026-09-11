program CacheLRU;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Collections;

type
  TCacheLRU = class
  private
    FDati: TDictionary<string, string>;
    FOrdine: TList<string>;
    FCapacita: Integer;
    procedure Tocca(const K: string);
  public
    constructor Create(ACapacita: Integer);
    destructor Destroy; override;
    procedure Metti(const K, V: string);
    function Prendi(const K: string; out V: string): Boolean;
    function Chiavi: string;
  end;

constructor TCacheLRU.Create(ACapacita: Integer);
begin
  inherited Create;
  FCapacita := ACapacita;
  FDati := TDictionary<string, string>.Create;
  FOrdine := TList<string>.Create;
end;

destructor TCacheLRU.Destroy;
begin
  FOrdine.Free;
  FDati.Free;
  inherited;
end;

procedure TCacheLRU.Tocca(const K: string);
begin
  FOrdine.Remove(K);
  FOrdine.Add(K);
end;

procedure TCacheLRU.Metti(const K, V: string);
begin
  FDati.AddOrSetValue(K, V);
  Tocca(K);
  while FOrdine.Count > FCapacita do
  begin
    FDati.Remove(FOrdine[0]);
    FOrdine.Delete(0);
  end;
end;

function TCacheLRU.Prendi(const K: string;
  out V: string): Boolean;
begin
  Result := FDati.TryGetValue(K, V);
  if Result then
    Tocca(K);
end;

function TCacheLRU.Chiavi: string;
begin
  Result := string.Join(',', FOrdine.ToArray);
end;

var
  C: TCacheLRU;
  V: string;
begin
  C := TCacheLRU.Create(2);
  try
    C.Metti('a', '1');
    C.Metti('b', '2');
    C.Prendi('a', V);
    C.Metti('c', '3');
    WriteLn(C.Chiavi, ' ', C.Prendi('b', V));
  finally
    C.Free;
  end;
end.
