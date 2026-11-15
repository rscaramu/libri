List<Decimal> temperature = new List<Decimal>{
    18.5, 21.0, 16.2, 24.8, 19.5 };
Decimal somma = 0;
Decimal minima = temperature[0];
Decimal massima = temperature[0];
for (Decimal t : temperature) {
    somma += t;
    minima = Math.min(minima, t);
    massima = Math.max(massima, t);
}
Decimal media = somma.divide(temperature.size(), 1);
System.debug(media);
System.debug(minima);
System.debug(massima);
