program MassimoArray;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Defaults;

type
  TArr = class
    class function Massimo<T>(const A: array of T): T; static;
  end;

class function TArr.Massimo<T>(const A: array of T): T;
var
  I: Integer;
  C: IComparer<T>;
begin
  if Length(A) = 0 then
    raise EArgumentException.Create('array vuoto');
  C := TComparer<T>.Default;
  Result := A[0];
  for I := 1 to High(A) do
    if C.Compare(A[I], Result) > 0 then
      Result := A[I];
end;

var
  D: Double;
  S: string;
begin
  D := TArr.Massimo<Double>([1.5, 9.25, 3.0]);
  WriteLn(D:0:2);
  S := TArr.Massimo<string>(['zeta', 'alfa', 'omega']);
  WriteLn(S);
end.
