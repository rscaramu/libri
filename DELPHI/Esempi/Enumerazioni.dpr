program Enumerazioni;

{$APPTYPE CONSOLE}

type
  TGiorno = (Lun, Mar, Mer, Gio, Ven, Sab, Dom);
  TLivello = (Basso = 1, Medio = 5, Alto = 10);

var
  G: TGiorno;
begin
  G := Mer;
  WriteLn(Ord(G), ' ', Ord(Dom), ' ', Ord(Low(TGiorno)));
  WriteLn(Succ(G) = Gio, ' ', G < Sab);
  Inc(G, 2);
  WriteLn(Ord(G));
  for G := Lun to Dom do
    Write(Ord(G) + 1, ' ');
  WriteLn;
  WriteLn(Ord(Medio), ' ', SizeOf(TGiorno), ' ',
    Ord(High(TGiorno)));
  G := TGiorno(5);
  WriteLn(Ord(G));
end.
