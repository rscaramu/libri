public with sharing class ControllerRiepilogo {

    public class Scheda {
        @AuraEnabled public String nome;
        @AuraEnabled public Integer contatti;
        @AuraEnabled public Decimal vinto;
        @AuraEnabled public Boolean rilevante;
    }

    @AuraEnabled(cacheable=true)
    public static Scheda scheda(Id azienda) {
        Account a = [
            SELECT Name,
                (SELECT Id FROM Contacts),
                (SELECT Amount FROM Opportunities
                    WHERE IsWon = true)
            FROM Account
            WHERE Id = :azienda
            WITH USER_MODE
        ];
        Scheda s = new Scheda();
        s.nome = a.Name;
        s.contatti = a.Contacts.size();
        s.vinto = 0;
        for (Opportunity o : a.Opportunities) {
            s.vinto += o.Amount ?? 0;
        }
        s.rilevante = s.vinto >= 100000;
        return s;
    }
}
