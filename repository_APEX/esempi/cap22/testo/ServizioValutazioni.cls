public with sharing class ServizioValutazioni {

    public static Integer imposta(
            Set<Id> aziende, String valore) {
        List<Account> daScrivere = new List<Account>();
        for (Account a : [SELECT Id, Rating
                FROM Account WHERE Id IN :aziende]) {
            if (a.Rating != valore) {
                a.Rating = valore;
                daScrivere.add(a);
            }
        }
        update daScrivere;
        return daScrivere.size();
    }
}
