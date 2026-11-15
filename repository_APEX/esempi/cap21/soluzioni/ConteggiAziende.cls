public with sharing class ConteggiAziende {

    public static Map<Id, Integer> contaContatti(
            List<Account> aziende) {
        Map<Id, Integer> esito = new Map<Id, Integer>();
        for (Account a : aziende) {
            esito.put(a.Id, 0);
        }
        for (AggregateResult r : [
                SELECT AccountId az, COUNT(Id) n
                FROM Contact
                WHERE AccountId IN :esito.keySet()
                GROUP BY AccountId]) {
            esito.put((Id) r.get('az'),
                (Integer) r.get('n'));
        }
        return esito;
    }
}
