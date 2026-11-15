String assente;
String presente = 'Apex';
System.debug(assente?.length());
System.debug(presente?.length());
Integer misura = assente?.length() ?? 0;
System.debug(misura);
String etichetta = assente ?? 'non indicato';
System.debug(etichetta);
