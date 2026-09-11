program Confronti;

{$APPTYPE CONSOLE}

uses
  SysUtils, Generics.Defaults;

type
  TUtil = class
    class function Massimo<T>(const A, B: T): T; static;
    class function Uguali<T>(const A, B: T): Boolean; static;
  end;

class function TUtil.Massimo<T>(const A, B: T): T;
begin
  if TComparer<T>.Default.Compare(A, B) >= 0 then
    Result := A
  else
    Result := B;
end;

class function TUtil.Uguali<T>(const A, B: T): Boolean;
begin
  Result := TEqualityComparer<T>.Default.Equals(A, B);
end;

var
  I: Integer;
  S: string;
  B: Boolean;
begin
  I := TUtil.Massimo<Integer>(3, 9);
  WriteLn(I);
  S := TUtil.Massimo<string>('pera', 'mela');
  WriteLn(S);
  B := TUtil.Uguali<Double>(0.5, 0.5);
  WriteLn(B);
end.
