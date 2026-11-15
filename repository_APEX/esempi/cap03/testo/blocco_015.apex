Integer anno = 2026;
Integer numero = 417;
String codice = 'ORD-' + anno + '-'
    + String.valueOf(numero).leftPad(5, '0');
System.debug(codice);
