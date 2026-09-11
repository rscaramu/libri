program Varianti;

{$APPTYPE CONSOLE}

type
  TForma = (Cerchio, Rettangolo);
  TFigura = record
    case Tipo: TForma of
      Cerchio: (Raggio: Double);
      Rettangolo: (Base, Altezza: Double);
  end;

function Area(const F: TFigura): Double;
begin
  case F.Tipo of
    Cerchio: Result := 3.14159 * F.Raggio * F.Raggio;
    Rettangolo: Result := F.Base * F.Altezza;
  else
    Result := 0;
  end;
end;

var
  F: TFigura;
begin
  F.Tipo := Cerchio;
  F.Raggio := 1;
  WriteLn(Area(F):0:3);
  F.Tipo := Rettangolo;
  F.Base := 2; F.Altezza := 3;
  WriteLn(Area(F):0:1);
  WriteLn(SizeOf(TFigura));
end.
