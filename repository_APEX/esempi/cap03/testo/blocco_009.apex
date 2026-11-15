String modello = 'Gentile {0}, ordine {1} spedito.';
String testo = String.format(modello,
    new List<Object>{ 'sig. Neri', 'ORD-2026-00417' });
System.debug(testo);
