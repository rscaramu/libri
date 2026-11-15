List<Misurabile> locali = new List<Misurabile>{
    new Stanza(4, 5), new Stanza(3, 3.5),
    new Terrazzo(12) };
Decimal totale = 0;
for (Misurabile locale : locali) {
    totale += locale.superficie();
}
System.debug(totale);
