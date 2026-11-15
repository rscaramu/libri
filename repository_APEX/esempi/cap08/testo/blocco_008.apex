Veicolo mezzo = new Furgone('FX123AB', 1200);
System.debug(mezzo instanceof Furgone);
if (mezzo instanceof Furgone) {
    Furgone furgone = (Furgone) mezzo;
    System.debug(furgone.puoCaricare(800));
}
