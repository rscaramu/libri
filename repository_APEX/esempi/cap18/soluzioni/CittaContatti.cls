public class CittaContatti {

    public static void copia(List<Contact> contatti) {
        Set<Id> aziende = new Set<Id>();
        for (Contact c : contatti) {
            if (c.AccountId != null) {
                aziende.add(c.AccountId);
            }
        }
        Map<Id, Account> perId = new Map<Id, Account>([
            SELECT BillingCity FROM Account
            WHERE Id IN :aziende]);
        List<Contact> daScrivere = new List<Contact>();
        for (Contact c : contatti) {
            Account a = perId.get(c.AccountId);
            if (a != null) {
                daScrivere.add(new Contact(Id = c.Id,
                    MailingCity = a.BillingCity));
            }
        }
        update daScrivere;
    }
}
