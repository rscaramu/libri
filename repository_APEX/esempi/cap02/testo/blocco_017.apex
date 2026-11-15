final Decimal ALIQUOTA = 0.22;
Integer pezzi = 36;
Decimal prezzoUnitario = 4.75;
Decimal imponibile = pezzi * prezzoUnitario;
Decimal imposta = (imponibile * ALIQUOTA)
    .setScale(2, RoundingMode.HALF_UP);
Decimal totale = imponibile + imposta;
System.debug('Imponibile: ' + imponibile);
System.debug('Imposta: ' + imposta);
System.debug('Totale: ' + totale);
