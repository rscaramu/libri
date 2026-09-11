program Intervallo;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Defaults;

type
  TIntervallo<T> = record
    Minimo, Massimo: T;
    function Contiene(const V: T): Boolean;
  end;

function TIntervallo<T>.Contiene(const V: T): Boolean;
var
  C: IComparer<T>;
begin
  C := TComparer<T>.Default;
  Result := (C.Compare(V, Minimo) >= 0) and
    (C.Compare(V, Massimo) <= 0);
end;

var
  I: TIntervallo<Integer>;
  S: TIntervallo<string>;
begin
  I.Minimo := 1; I.Massimo := 10;
  S.Minimo := 'b'; S.Massimo := 'f';
  WriteLn(I.Contiene(5), ' ', I.Contiene(11), ' ',
    S.Contiene('d'), ' ', S.Contiene('z'));
end.
