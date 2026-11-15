@IsTest
public class FabbricaScenari {

    public static Account aziendaCompleta(
            Integer contatti, Integer trattative) {
        Account azienda = FabbricaDati.aziende(1)[0];
        FabbricaDati.contatti(azienda, contatti);
        List<Opportunity> affari =
            new List<Opportunity>();
        for (Integer i = 0; i < trattative; i++) {
            affari.add(new Opportunity(
                Name = 'Affare ' + i,
                AccountId = azienda.Id,
                StageName = 'Closed Won',
                CloseDate = Date.today(),
                Amount = 1000));
        }
        insert affari;
        return azienda;
    }
}
