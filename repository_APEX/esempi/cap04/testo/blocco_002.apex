Decimal importo = 740;
Decimal sconto;
if (importo >= 1000) {
    sconto = 0.10;
} else if (importo >= 500) {
    sconto = 0.05;
} else {
    sconto = 0;
}
System.debug(sconto);
