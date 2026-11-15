public with sharing class ServizioContatori {

    public static void aggiorna(Set<Id> aziende) {
        Map<Id, Integer> conteggi = new Map<Id, Integer>();
        for (AggregateResult r : [
                SELECT AccountId az, COUNT(Id) n
                FROM Contact WHERE AccountId IN :aziende
                GROUP BY AccountId]) {
            conteggi.put((Id) r.get('az'),
                (Integer) r.get('n'));
        }
        List<Account> daScrivere = new List<Account>();
        for (Account a : [SELECT Id, NumberOfEmployees
                FROM Account WHERE Id IN :aziende]) {
            Integer nuovo = conteggi.get(a.Id) ?? 0;
            if (a.NumberOfEmployees != nuovo) {
                a.NumberOfEmployees = nuovo;
                daScrivere.add(a);
            }
        }
        if (daScrivere.isEmpty()) {
            return;
        }
        GestoreTrigger.sospendi('GestoreAziende');
        try {
            update daScrivere;
        } finally {
            GestoreTrigger.riattiva('GestoreAziende');
        }
    }
}
