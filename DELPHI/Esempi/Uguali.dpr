program Uguali;

{$APPTYPE CONSOLE}

uses
  SysUtils, TypInfo, Variants;

type
  {$M+}
  TPunto = class
  private
    FX, FY: Integer;
  published
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
  end;
  {$M-}

function Uguali(A, B: TObject): Boolean;
var
  Lista: PPropList;
  N, I: Integer;
begin
  if A.ClassType <> B.ClassType then
    Exit(False);
  Result := True;
  N := GetPropList(A, Lista);
  try
    for I := 0 to N - 1 do
      if string(GetPropValue(A, Lista^[I]^.Name)) <>
         string(GetPropValue(B, Lista^[I]^.Name)) then
        Exit(False);
  finally
    FreeMem(Lista);
  end;
end;

var
  P, Q: TPunto;
begin
  P := TPunto.Create;
  Q := TPunto.Create;
  try
    P.X := 1; P.Y := 2;
    Q.X := 1; Q.Y := 2;
    WriteLn(Uguali(P, Q));
    Q.Y := 3;
    WriteLn(Uguali(P, Q));
  finally
    P.Free;
    Q.Free;
  end;
end.
