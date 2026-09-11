program Ordinamento;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Defaults, Generics.Collections;

type
  TPersona = record
    Nome: string;
    Eta: Integer;
  end;

function P(const N: string; E: Integer): TPersona;
begin
  Result.Nome := N;
  Result.Eta := E;
end;

var
  L: TList<TPersona>;
  X: TPersona;
begin
  L := TList<TPersona>.Create;
  try
    L.Add(P('Carlo', 40));
    L.Add(P('Anna', 25));
    L.Add(P('Bruno', 33));
    L.Sort(TComparer<TPersona>.Construct(
      function(const A, B: TPersona): Integer
      begin
        Result := A.Eta - B.Eta;
      end));
    for X in L do
      Write(X.Nome, ' ');
    WriteLn;
    L.Sort(TComparer<TPersona>.Construct(
      function(const A, B: TPersona): Integer
      begin
        Result := CompareStr(A.Nome, B.Nome);
      end));
    for X in L do
      Write(X.Nome, ' ');
    WriteLn;
  finally
    L.Free;
  end;
end.
