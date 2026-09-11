{ Binario - Manuale completo di Free Pascal e Lazarus }
program Binario;
{$mode objfpc}{$H+}

procedure StampaBinario(N: Cardinal);
begin
  if N > 1 then
    StampaBinario(N div 2);
  Write(N mod 2);
end;

var
  V: Cardinal;
begin
  for V in [0, 1, 5, 10, 255] do
  begin
    Write(V:4, ' = ');
    StampaBinario(V);
    WriteLn;
  end;
end.
