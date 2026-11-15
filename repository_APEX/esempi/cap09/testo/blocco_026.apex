List<Offerta> offerte = new List<Offerta>{
    new Offerta('Alfa', 1250),
    new Offerta('Beta', 1190),
    new Offerta('Gamma', 1320) };
offerte.sort();
System.debug(offerte[0].fornitore);
