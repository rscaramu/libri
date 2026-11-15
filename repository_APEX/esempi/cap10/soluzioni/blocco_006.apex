for (Integer i = 0; i < 5; i++) {
    Sessione.registraAccesso();
}
System.debug(Sessione.totale());
