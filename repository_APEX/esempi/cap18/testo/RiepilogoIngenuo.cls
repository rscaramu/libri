public class RiepilogoIngenuo {

    public static void aggiorna(List<Account> aziende) {
        for (Account a : aziende) {
            Integer n = [SELECT COUNT() FROM Contact
                WHERE AccountId = :a.Id];
            a.Description = 'Contatti: ' + n;
            update a;
        }
    }
}
