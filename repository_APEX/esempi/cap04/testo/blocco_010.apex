for (Integer riga = 1; riga <= 3; riga++) {
    String testo = '';
    for (Integer col = 1; col <= 4; col++) {
        testo += (riga * col) + ' ';
    }
    System.debug(testo);
}
