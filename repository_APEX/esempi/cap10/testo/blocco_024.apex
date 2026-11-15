Validazione.Esito buono =
    Validazione.controlla('Ada Neri', 34);
Validazione.Esito cattivo = Validazione.controlla('', 12);
System.debug(buono.valido);
System.debug(cattivo.valido);
System.debug(cattivo.errori);
