Portafoglio p = new Portafoglio(200);
try {
    p.preleva(50);
    p.preleva(500);
    System.debug('Non si arriva qui');
} catch (SaldoInsufficienteException e) {
    System.debug(e.getMessage());
}
