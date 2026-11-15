Cliente c = new Cliente();
c.nome = 'Officine Riva';
c.citta = 'Bari';
c.ordini = 3;
String testo = JSON.serialize(c);
System.debug(testo.contains('"nome":"Officine Riva"'));
System.debug(testo.contains('"nota":null'));
String compatto = JSON.serialize(c, true);
System.debug(compatto.contains('nota'));
