public with sharing class ControllerCruscotto {

    public class Riga {
        @AuraEnabled public Id azienda;
        @AuraEnabled public String nome;
        @AuraEnabled public Integer aperte;
    }

    @AuraEnabled(cacheable=true)
    public static List<Riga> trattativeAperte() {
        List<Riga> righe = new List<Riga>();
        for (Account a : [
                SELECT Id, Name,
                    (SELECT Id FROM Opportunities
                        WHERE IsClosed = false)
                FROM Account
                WHERE BillingCountry = 'Italia'
                WITH USER_MODE
                ORDER BY Name]) {
            Riga r = new Riga();
            r.azienda = a.Id;
            r.nome = a.Name;
            r.aperte = a.Opportunities.size();
            righe.add(r);
        }
        return righe;
    }
}
