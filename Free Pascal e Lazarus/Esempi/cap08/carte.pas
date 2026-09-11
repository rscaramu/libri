{ Carte - Manuale completo di Free Pascal e Lazarus }
program Carte;
{$mode objfpc}{$H+}
type
  TSeme = (Denari, Coppe, Spade, Bastoni);
  TValore = 1..10;
  TCarta = record
    Seme: TSeme;
    Valore: TValore;
  end;
  TMazzo = array[0..39] of TCarta;

procedure Crea(out M: TMazzo);
var
  S: TSeme;
  V: TValore;
  I: Integer;
begin
  I := 0;
  for S := Low(TSeme) to High(TSeme) do
    for V := Low(TValore) to High(TValore) do
    begin
      M[I].Seme := S;
      M[I].Valore := V;
      Inc(I);
    end;
end;

var
  M: TMazzo;
  I: Integer;
begin
  Crea(M);
  for I in [0, 9, 10, 39] do
    WriteLn(I:2, ': ', M[I].Valore, ' di ', M[I].Seme);
end.
