public with sharing class RiepilogoAsincrono {

    @future
    public static void aggiorna(Set<Id> aziende) {
        System.debug('In esecuzione: '
            + System.isFuture());
        Riepilogo.aggiorna([SELECT Id FROM Account
            WHERE Id IN :aziende]);
    }
}
