for (StatoOrdine s : StatoOrdine.values()) {
    System.debug(s.ordinal() + ' ' + s.name());
}
StatoOrdine letto = StatoOrdine.valueOf('SPEDITO');
System.debug(letto == StatoOrdine.SPEDITO);
