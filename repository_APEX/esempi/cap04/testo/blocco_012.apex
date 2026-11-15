Decimal peso = 14.5;
Decimal costo;
if (peso <= 2) {
    costo = 6;
} else if (peso <= 10) {
    costo = 9;
} else {
    costo = 9 + (peso - 10) * 0.80;
}
System.debug(costo.setScale(2));
