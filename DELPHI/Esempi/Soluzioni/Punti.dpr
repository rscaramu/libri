program Punti;

{$APPTYPE CONSOLE}

type
  TPunto = class
  private
    FX, FY: Double;
  public
    constructor Create(AX, AY: Double);
    function Distanza(Altro: TPunto): Double;
    property X: Double read FX write FX;
    property Y: Double read FY write FY;
  end;

constructor TPunto.Create(AX, AY: Double);
begin
  inherited Create;
  FX := AX;
  FY := AY;
end;

function TPunto.Distanza(Altro: TPunto): Double;
begin
  Result := Sqrt(Sqr(FX - Altro.X) + Sqr(FY - Altro.Y));
end;

var
  A, B: TPunto;
begin
  A := TPunto.Create(0, 0);
  B := TPunto.Create(3, 4);
  try
    WriteLn(A.Distanza(B):0:1);
  finally
    B.Free;
    A.Free;
  end;
end.
