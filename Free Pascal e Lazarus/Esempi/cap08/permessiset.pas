{ PermessiSet - Manuale completo di Free Pascal e Lazarus }
program PermessiSet;
{$mode objfpc}{$H+}
type
  TPermesso = (pLettura, pScrittura, pEsecuzione);
  TPermessi = set of TPermesso;

function Descrivi(P: TPermessi): String;
const
  Lettere: array[TPermesso] of Char = ('r', 'w', 'x');
var
  K: TPermesso;
begin
  Result := '';
  for K := Low(TPermesso) to High(TPermesso) do
    if K in P then
      Result := Result + Lettere[K]
    else
      Result := Result + '-';
end;

var
  P: TPermessi;
begin
  P := [pLettura, pScrittura];
  WriteLn(Descrivi(P));
  WriteLn('Lettura? ', pLettura in P);
  Exclude(P, pLettura);
  Include(P, pEsecuzione);
  WriteLn(Descrivi(P));
  WriteLn('Tutti? ', P = [pLettura..pEsecuzione]);
end.
