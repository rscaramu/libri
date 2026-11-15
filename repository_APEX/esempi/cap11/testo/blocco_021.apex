try {
    System.debug(Anagrafe.registra('Lia', 34));
    System.debug(Anagrafe.registra('Ugo', 150));
} catch (EtaNonValidaException e) {
    System.debug('Errore: ' + e.getMessage());
}
