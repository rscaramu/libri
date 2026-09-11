program Pasqua;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function Pasqua(Anno: Integer): TDate;
var
  A, B, C, D, E, F, G, H, I, K, L, M, Mese, Giorno: Integer;
begin
  A := Anno mod 19;
  B := Anno div 100;
  C := Anno mod 100;
  D := B div 4;
  E := B mod 4;
  F := (B + 8) div 25;
  G := (B - F + 1) div 3;
  H := (19 * A + B - D - G + 15) mod 30;
  I := C div 4;
  K := C mod 4;
  L := (32 + 2 * E + 2 * I - H - K) mod 7;
  M := (A + 11 * H + 22 * L) div 451;
  Mese := (H + L - 7 * M + 114) div 31;
  Giorno := (H + L - 7 * M + 114) mod 31 + 1;
  Result := EncodeDate(Anno, Mese, Giorno);
end;

var
  A: Integer;
begin
  for A := 2024 to 2030 do
    WriteLn(A, ': ', FormatDateTime('dd"/"mm', Pasqua(A)));
end.
