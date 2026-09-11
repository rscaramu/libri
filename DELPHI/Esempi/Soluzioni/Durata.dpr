program Durata;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function DurataTesto(Secondi: Int64): string;
var
  G, H, M, S: Int64;
begin
  G := Secondi div 86400;
  H := (Secondi mod 86400) div 3600;
  M := (Secondi mod 3600) div 60;
  S := Secondi mod 60;
  Result := '';
  if G > 0 then
    Result := Format('%dg ', [G]);
  if (H > 0) or (Result <> '') then
    Result := Result + Format('%dh ', [H]);
  if Result <> '' then
    Result := Result + Format('%.2dm ', [M])
  else if M > 0 then
    Result := Result + Format('%dm ', [M]);
  Result := Result + Format('%.2ds', [S]);
end;

begin
  WriteLn(DurataTesto(2 * 86400 + 3 * 3600 + 4 * 60 + 5));
  WriteLn(DurataTesto(65));
  WriteLn(DurataTesto(7));
end.
