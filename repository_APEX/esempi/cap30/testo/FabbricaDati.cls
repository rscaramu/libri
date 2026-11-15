@IsTest
public class FabbricaDati {

    public static List<Account> aziende(Integer quante) {
        List<Account> esito = new List<Account>();
        for (Integer i = 0; i < quante; i++) {
            esito.add(new Account(
                Name = 'Azienda Test ' + i,
                BillingCity = 'Bari',
                BillingCountry = 'Italia'));
        }
        insert esito;
        return esito;
    }

    public static List<Contact> contatti(
            Account azienda, Integer quanti) {
        List<Contact> esito = new List<Contact>();
        for (Integer i = 0; i < quanti; i++) {
            esito.add(new Contact(
                LastName = 'Contatto ' + i,
                Email = 'c' + i + '@test.example',
                AccountId = azienda.Id));
        }
        insert esito;
        return esito;
    }

    public static Opportunity trattativa(
            Account azienda, Decimal importo) {
        Opportunity o = new Opportunity(
            Name = 'Trattativa Test',
            AccountId = azienda.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = importo);
        insert o;
        return o;
    }
}
