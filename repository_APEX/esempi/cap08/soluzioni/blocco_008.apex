Integer totale = 0;
for (Dipendente2 d : new List<Dipendente2>{
        new TempoPieno(), new TempoParziale(24),
        new TempoParziale(18) }) {
    totale += d.oreSettimanali();
}
System.debug(totale);
