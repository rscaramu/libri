String testo = 'Acconto di 150,00 euro, saldo di '
    + '320,50 euro e spese per 12,90 euro.';
Matcher m = Pattern.compile('(\\d+),(\\d{2}) euro')
    .matcher(testo);
Decimal somma = 0;
Integer trovati = 0;
while (m.find()) {
    somma += Decimal.valueOf(
        m.group(1) + '.' + m.group(2));
    trovati++;
}
System.debug(trovati);
System.debug(somma);
