try {
    throw new ScortaException('V-10', 40);
} catch (ScortaException e) {
    System.debug(e.getMessage());
    System.debug(e.codice + ': mancano ' + e.mancanti);
}
