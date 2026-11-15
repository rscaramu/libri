public with sharing class Inoltro {

    public static void riepilogo(Set<Id> aziende) {
        if (System.isFuture() || System.isBatch()) {
            Riepilogo.aggiorna([SELECT Id FROM Account
                WHERE Id IN :aziende]);
        } else {
            RiepilogoAsincrono.aggiorna(aziende);
        }
    }
}
