program RecordMetodi;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TPunto = record
  private
    FX, FY: Double;
  public
    constructor Create(AX, AY: Double);
    function Distanza(const Altro: TPunto): Double;
    function Testo: string;
    procedure Sposta(DX, DY: Double);
    property X: Double read FX;
    property Y: Double read FY;
    class function Origine: TPunto; static;
  end;

constructor TPunto.Create(AX, AY: Double);
begin
  FX := AX;
  FY := AY;
end;

function TPunto.Distanza(const Altro: TPunto): Double;
begin
  Result := Sqrt(Sqr(FX - Altro.FX) + Sqr(FY - Altro.FY));
end;

function TPunto.Testo: string;
begin
  Result := Format('(%.1f, %.1f)', [FX, FY]);
end;

procedure TPunto.Sposta(DX, DY: Double);
begin
  FX := FX + DX;
  FY := FY + DY;
end;

class function TPunto.Origine: TPunto;
begin
  Result := TPunto.Create(0, 0);
end;

var
  P, Q: TPunto;
begin
  P := TPunto.Create(3, 4);
  Q := P;
  Q.Sposta(1, 1);
  WriteLn(P.Testo, ' ', Q.Testo);
  WriteLn(P.Distanza(TPunto.Origine):0:1);
  WriteLn(SizeOf(TPunto));
end.
