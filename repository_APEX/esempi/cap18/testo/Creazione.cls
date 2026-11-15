public class Creazione {

    public static Boolean aziendaConContatti(
            String nome, List<String> cognomi) {
        Savepoint punto = Database.setSavepoint();
        try {
            Account a = new Account(
                Name = nome, BillingCountry = 'Prova');
            insert a;
            List<Contact> persone = new List<Contact>();
            for (String cognome : cognomi) {
                persone.add(new Contact(
                    LastName = cognome,
                    AccountId = a.Id));
            }
            insert persone;
            return true;
        } catch (DmlException e) {
            Database.rollback(punto);
            return false;
        }
    }
}
