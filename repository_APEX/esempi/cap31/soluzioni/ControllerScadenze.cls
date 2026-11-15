public with sharing class ControllerScadenze {

    public class Voce {
        @AuraEnabled public String nome;
        @AuraEnabled public Decimal importo;
        @AuraEnabled public Integer giorni;
    }

    @AuraEnabled(cacheable=true)
    public static List<Voce> aperte(Id azienda) {
        List<Voce> voci = new List<Voce>();
        for (Opportunity o : [
                SELECT Name, Amount, CloseDate
                FROM Opportunity
                WHERE AccountId = :azienda
                    AND IsClosed = false
                WITH USER_MODE
                ORDER BY CloseDate]) {
            Voce v = new Voce();
            v.nome = o.Name;
            v.importo = o.Amount;
            v.giorni = Date.today().daysBetween(o.CloseDate);
            voci.add(v);
        }
        return voci;
    }
}
