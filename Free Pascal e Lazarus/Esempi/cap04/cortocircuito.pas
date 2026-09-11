{ CortoCircuito - Manuale completo di Free Pascal e Lazarus }
program CortoCircuito;
{$mode objfpc}{$H+}

function Chiamata(Msg: String; Valore: Boolean): Boolean;
begin
  WriteLn('  valutato: ', Msg);
  Result := Valore;
end;

begin
  WriteLn('False and X:');
  if Chiamata('primo', False) and
     Chiamata('secondo', True) then
    WriteLn('  vero')
  else
    WriteLn('  falso');
  WriteLn('True or X:');
  if Chiamata('primo', True) or
     Chiamata('secondo', False) then
    WriteLn('  vero');
end.
