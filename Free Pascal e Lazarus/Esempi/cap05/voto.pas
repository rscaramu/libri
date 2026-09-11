{ Voto - Manuale completo di Free Pascal e Lazarus }
program Voto;
{$mode objfpc}{$H+}
var
  V: Integer;
begin
  for V in [4, 6, 8, 10] do
    if V < 6 then
      WriteLn(V, ': insufficiente')
    else if V < 8 then
      WriteLn(V, ': sufficiente')
    else if V < 10 then
      WriteLn(V, ': buono')
    else
      WriteLn(V, ': eccellente');
end.
