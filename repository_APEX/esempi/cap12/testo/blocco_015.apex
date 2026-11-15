List<Voce> voci = new List<Voce>{
    new Voce('V-10', 0.12), new Voce('D-08', 0.05),
    new Voce('R-06', 0.02) };
String testo = JSON.serialize(voci);
List<Voce> lette = (List<Voce>) JSON.deserialize(
    testo, List<Voce>.class);
Decimal somma = 0;
for (Voce v : lette) {
    somma += v.prezzo;
}
System.debug(lette.size());
System.debug(somma.divide(lette.size(), 3));
