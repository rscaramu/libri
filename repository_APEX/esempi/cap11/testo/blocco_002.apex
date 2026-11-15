String testo = '12a';
Integer numero;
try {
    numero = Integer.valueOf(testo);
    System.debug('Conversione riuscita');
} catch (TypeException e) {
    System.debug('Valore non numerico: ' + testo);
    numero = 0;
}
System.debug(numero);
