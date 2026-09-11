program Sottointervalli;

{$APPTYPE CONSOLE}

{$R+}

type
  TGiorno = 1..31;
  TMese = 1..12;
  TMinuscola = 'a'..'z';

var
  G: TGiorno;
  M: TMese;
  L: TMinuscola;
begin
  G := 15;
  M := 12;
  L := 'q';
  WriteLn(G, '/', M, ' ', L);
  WriteLn(Low(TGiorno), '..', High(TGiorno));
  WriteLn(SizeOf(TGiorno), ' ', SizeOf(TMese));
end.
