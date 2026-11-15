List<Decimal> prezzi =
    new List<Decimal>{ 12.50, 8.00, 31.90 };
Decimal totale = 0;
for (Decimal p : prezzi) {
    totale += p;
}
System.debug(totale);
for (Integer i = 0; i < prezzi.size(); i++) {
    prezzi[i] = prezzi[i] * 2;
}
System.debug(prezzi);
