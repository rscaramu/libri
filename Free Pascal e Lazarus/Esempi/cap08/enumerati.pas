{ Enumerati - Manuale completo di Free Pascal e Lazarus }
program Enumerati;
{$mode objfpc}{$H+}
type
  TGiorno = (Lun, Mar, Mer, Gio, Ven, Sab, Dom);
  TSemaforo = (Rosso, Giallo, Verde);
var
  G: TGiorno;
  S: TSemaforo;
begin
  for G := Lun to Dom do
    Write(Ord(G), ' ');
  WriteLn;
  G := Mer;
  WriteLn('Successivo di Mer: ', Ord(Succ(G)));
  WriteLn('Mer e'' feriale? ', G < Sab);
  WriteLn('High(TGiorno) = ', Ord(High(TGiorno)));
  S := Rosso;
  Inc(S);
  WriteLn('Dopo il rosso: ', S);
  S := TSemaforo(2);
  WriteLn('TSemaforo(2) = ', S);
end.
