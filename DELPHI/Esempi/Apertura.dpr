program Apertura;

{$APPTYPE CONSOLE}

type
  TGiorno = (Lun, Mar, Mer, Gio, Ven, Sab, Dom);
  TGiorni = set of TGiorno;

function Aperto(const Orari: TGiorni; G: TGiorno): Boolean;
begin
  Result := G in Orari;
end;

function Conta(const Orari: TGiorni): Integer;
var
  G: TGiorno;
begin
  Result := 0;
  for G in Orari do
    Inc(Result);
end;

const
  Negozio: TGiorni = [Lun..Sab] - [Gio];
begin
  WriteLn(Aperto(Negozio, Mar), ' ', Aperto(Negozio, Gio));
  WriteLn(Conta(Negozio));
end.
