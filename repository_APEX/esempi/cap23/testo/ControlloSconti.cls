public with sharing class ControlloSconti {

    public static Boolean ammesso(Decimal percentuale) {
        Automazione__c a = Automazione__c.getInstance();
        Decimal massimo = a?.Sconto_Massimo__c ?? 0;
        return percentuale <= massimo;
    }
}
