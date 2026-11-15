Dipendente3 d = new Dipendente3();
d.nome = 'Elena Sala';
d.reparto = 'Acquisti';
d.annoAssunzione = 2019;
String testo = JSON.serializePretty(d);
System.debug(testo);
Dipendente3 letto = (Dipendente3) JSON.deserialize(
    testo, Dipendente3.class);
System.debug(letto.nome == d.nome
    && letto.reparto == d.reparto
    && letto.annoAssunzione == d.annoAssunzione);
