program Insiemi;

{$APPTYPE CONSOLE}

type
  TGiorno = (Lun, Mar, Mer, Gio, Ven, Sab, Dom);
  TGiorni = set of TGiorno;
  TCifre = set of '0'..'9';

var
  Lavorativi, Festivi, Tutti: TGiorni;
  G: TGiorno;
  Cifre: TCifre;
begin
  Lavorativi := [Lun..Ven];
  Festivi := [Sab, Dom];
  Tutti := Lavorativi + Festivi;
  WriteLn(Mer in Lavorativi, ' ', Sab in Lavorativi);
  WriteLn(Tutti = [Lun..Dom], ' ', Festivi <= Tutti);
  Exclude(Lavorativi, Ven);
  Include(Festivi, Ven);
  for G in Festivi do
    Write(Ord(G), ' ');
  WriteLn;
  WriteLn(Lavorativi * Festivi = [], ' ',
    Ord(High(TGiorno)) + 1);
  Cifre := ['0'..'9'];
  WriteLn('7' in Cifre, ' ', 'x' in Cifre);
  WriteLn(SizeOf(TGiorni), ' ', SizeOf(TCifre));
end.
