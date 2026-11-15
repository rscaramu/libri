public class Riepilogo {

    public static void aggiorna(List<Account> aziende) {
        Set<Id> chiavi = new Set<Id>();
        for (Account a : aziende) {
            chiavi.add(a.Id);
        }
        Map<Id, Integer> conteggi = new Map<Id, Integer>();
        for (AggregateResult r : [
                SELECT AccountId az, COUNT(Id) n
                FROM Contact
                WHERE AccountId IN :chiavi
                GROUP BY AccountId]) {
            conteggi.put((Id) r.get('az'),
                (Integer) r.get('n'));
        }
        List<Account> daScrivere = new List<Account>();
        for (Id chiave : chiavi) {
            daScrivere.add(new Account(Id = chiave,
                Description = 'Contatti: '
                    + (conteggi.get(chiave) ?? 0)));
        }
        update daScrivere;
    }
}
