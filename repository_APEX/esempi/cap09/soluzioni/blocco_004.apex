Decimal totale = 0;
for (Tassabile t : new List<Tassabile>{
        new Immobile(200000), new Automobile(85) }) {
    totale += t.imposta();
}
System.debug(totale);
