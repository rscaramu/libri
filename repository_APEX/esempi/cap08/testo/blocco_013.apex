List<Object> misto = new List<Object>{
    42, 'testo', Date.newInstance(2026, 1, 1),
    new Quadrato(2) };
for (Object elemento : misto) {
    if (elemento instanceof Integer) {
        System.debug('Intero: ' + elemento);
    } else if (elemento instanceof String) {
        System.debug('Stringa: ' + elemento);
    } else if (elemento instanceof Figura) {
        System.debug('Figura: '
            + ((Figura) elemento).area());
    } else {
        System.debug('Altro: ' + elemento);
    }
}
