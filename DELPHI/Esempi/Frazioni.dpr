program Frazioni;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TFrazione = record
  private
    FNum, FDen: Integer;
    class function MCD(A, B: Integer): Integer; static;
  public
    constructor Create(ANum, ADen: Integer);
    class operator Add(const A, B: TFrazione): TFrazione;
    class operator Multiply(
      const A, B: TFrazione): TFrazione;
    class operator Equal(const A, B: TFrazione): Boolean;
    class operator NotEqual(
      const A, B: TFrazione): Boolean;
    class operator Implicit(
      const F: TFrazione): string;
  end;

class function TFrazione.MCD(A, B: Integer): Integer;
var
  R: Integer;
begin
  A := Abs(A); B := Abs(B);
  while B <> 0 do
  begin
    R := A mod B; A := B; B := R;
  end;
  Result := A;
end;

constructor TFrazione.Create(ANum, ADen: Integer);
var
  D: Integer;
begin
  if ADen = 0 then
    raise EArgumentException.Create('denominatore zero');
  if ADen < 0 then
  begin
    ANum := -ANum; ADen := -ADen;
  end;
  D := MCD(ANum, ADen);
  if D = 0 then D := 1;
  FNum := ANum div D;
  FDen := ADen div D;
end;

class operator TFrazione.Add(
  const A, B: TFrazione): TFrazione;
begin
  Result := TFrazione.Create(
    A.FNum * B.FDen + B.FNum * A.FDen, A.FDen * B.FDen);
end;

class operator TFrazione.Multiply(
  const A, B: TFrazione): TFrazione;
begin
  Result := TFrazione.Create(A.FNum * B.FNum,
    A.FDen * B.FDen);
end;

class operator TFrazione.Equal(
  const A, B: TFrazione): Boolean;
begin
  Result := (A.FNum = B.FNum) and (A.FDen = B.FDen);
end;

class operator TFrazione.NotEqual(
  const A, B: TFrazione): Boolean;
begin
  Result := not (A = B);
end;

class operator TFrazione.Implicit(
  const F: TFrazione): string;
begin
  if F.FDen = 1 then
    Result := IntToStr(F.FNum)
  else
    Result := Format('%d/%d', [F.FNum, F.FDen]);
end;

var
  A, B: TFrazione;
  S: string;
begin
  A := TFrazione.Create(1, 2);
  B := TFrazione.Create(2, 6);
  S := A + B; WriteLn(S);
  S := A * B; WriteLn(S);
  S := TFrazione.Create(4, -8); WriteLn(S);
  S := A + A; WriteLn(S);
  WriteLn(B = TFrazione.Create(1, 3), ' ', A <> B);
end.
