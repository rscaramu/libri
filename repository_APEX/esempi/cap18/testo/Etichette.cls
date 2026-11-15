public class Etichette {

    public static void applica(List<Opportunity> lista) {
        Set<Id> chiavi = new Set<Id>();
        for (Opportunity o : lista) {
            if (o.AccountId != null) {
                chiavi.add(o.AccountId);
            }
        }
        Map<Id, Account> aziende = new Map<Id, Account>([
            SELECT Name, BillingCity FROM Account
            WHERE Id IN :chiavi]);
        List<Opportunity> daScrivere =
            new List<Opportunity>();
        for (Opportunity o : lista) {
            Account a = aziende.get(o.AccountId);
            if (a == null) {
                continue;
            }
            daScrivere.add(new Opportunity(Id = o.Id,
                Description = a.Name + ' - '
                    + a.BillingCity));
        }
        update daScrivere;
    }
}
