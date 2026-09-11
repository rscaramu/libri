program Secondi;

{$APPTYPE CONSOLE}

const
  SecondiPerMinuto = 60;
  MinutiPerOra = 60;
  OrePerGiorno = 24;
  SecondiPerGiorno = SecondiPerMinuto * MinutiPerOra *
    OrePerGiorno;
begin
  WriteLn(SecondiPerGiorno);
end.
