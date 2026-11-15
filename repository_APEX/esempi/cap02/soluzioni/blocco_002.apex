Decimal chilometri = 412;
Decimal litri = 28.5;
Decimal consumo = chilometri.divide(
    litri, 1, RoundingMode.HALF_UP);
System.debug(consumo);
