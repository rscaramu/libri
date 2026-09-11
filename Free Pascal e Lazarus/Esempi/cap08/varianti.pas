{ Varianti - Manuale completo di Free Pascal e Lazarus }
program Varianti;
{$mode objfpc}{$H+}
type
  TTipoForma = (tfCerchio, tfRettangolo);
  TForma = record
    Nome: String[20];
    case Tipo: TTipoForma of
      tfCerchio: (Raggio: Double);
      tfRettangolo: (Base, Altezza: Double);
  end;

function Area(const F: TForma): Double;
begin
  case F.Tipo of
    tfCerchio: Result := Pi * F.Raggio * F.Raggio;
    tfRettangolo: Result := F.Base * F.Altezza;
  else
    Result := 0;
  end;
end;

var
  F: TForma;
begin
  F.Nome := 'ruota';
  F.Tipo := tfCerchio;
  F.Raggio := 2;
  WriteLn(F.Nome, ': ', Area(F):0:2);
  F.Nome := 'porta';
  F.Tipo := tfRettangolo;
  F.Base := 0.8;
  F.Altezza := 2.1;
  WriteLn(F.Nome, ': ', Area(F):0:2);
  WriteLn('SizeOf(TForma) = ', SizeOf(TForma));
end.
