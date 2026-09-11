{ Insiemi - Manuale completo di Free Pascal e Lazarus }
program Insiemi;
{$mode objfpc}{$H+}
type
  TGiorno = (Lun, Mar, Mer, Gio, Ven, Sab, Dom);
  TGiorni = set of TGiorno;
  TCaratteri = set of Char;
var
  Feriali, Festivi, Apertura: TGiorni;
  G: TGiorno;
  Vocali: TCaratteri;
  C: Char;
  N: Integer;
begin
  Feriali := [Lun..Ven];
  Festivi := [Sab, Dom];
  Apertura := Feriali + [Sab] - [Mer];
  Write('Apertura: ');
  for G in Apertura do
    Write(G, ' ');
  WriteLn;
  WriteLn('Feriali * Apertura = Feriali? ',
          Feriali * Apertura = Feriali);
  WriteLn('[Sab] <= Festivi? ', [Sab] <= Festivi);
  WriteLn('Insieme vuoto: ', Feriali * Festivi = []);
  Include(Apertura, Mer);
  Exclude(Apertura, Sab);
  WriteLn('Apertura = Feriali? ', Apertura = Feriali);

  Vocali := ['a', 'e', 'i', 'o', 'u'];
  N := 0;
  for C in 'programmazione' do
    if C in Vocali then
      Inc(N);
  WriteLn('Vocali: ', N);
  WriteLn('SizeOf(TGiorni) = ', SizeOf(TGiorni),
          ', SizeOf(TCaratteri) = ', SizeOf(TCaratteri));
end.
