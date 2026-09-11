{ RecordAvanzati - Manuale completo di Free Pascal e Lazarus }
program RecordAvanzati;
{$mode objfpc}{$H+}
{$modeswitch advancedrecords}
type
  TPunto = record
    X, Y: Double;
    procedure Sposta(DX, DY: Double);
    function Distanza(const P: TPunto): Double;
    class function Crea(AX, AY: Double): TPunto; static;
  end;

procedure TPunto.Sposta(DX, DY: Double);
begin
  X := X + DX;
  Y := Y + DY;
end;

function TPunto.Distanza(const P: TPunto): Double;
begin
  Result := Sqrt(Sqr(X - P.X) + Sqr(Y - P.Y));
end;

class function TPunto.Crea(AX, AY: Double): TPunto;
begin
  Result.X := AX;
  Result.Y := AY;
end;

var
  A, B: TPunto;
begin
  A := TPunto.Crea(0, 0);
  B := TPunto.Crea(3, 4);
  WriteLn('Distanza: ', A.Distanza(B):0:1);
  B.Sposta(1, 1);
  WriteLn('B = (', B.X:0:0, ', ', B.Y:0:0, ')');
end.
