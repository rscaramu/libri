public with sharing class ControllerSconti {

    @AuraEnabled
    public static Decimal applica(Id trattativa,
            Decimal percentuale) {
        if (percentuale == null || percentuale < 0
                || percentuale > 30) {
            throw nuovoErrore(
                'Lo sconto deve essere fra 0 e 30');
        }
        try {
            Opportunity o = [SELECT Amount
                FROM Opportunity
                WHERE Id = :trattativa
                WITH USER_MODE];
            o.Amount = (o.Amount
                * (100 - percentuale) / 100).setScale(2);
            update as user o;
            return o.Amount;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,
                e.getStackTraceString());
            throw nuovoErrore(
                'Impossibile applicare lo sconto');
        }
    }

    private static AuraHandledException nuovoErrore(
            String messaggio) {
        AuraHandledException e =
            new AuraHandledException(messaggio);
        e.setMessage(messaggio);
        return e;
    }
}
