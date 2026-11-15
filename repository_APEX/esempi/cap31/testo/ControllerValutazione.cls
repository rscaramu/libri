public with sharing class ControllerValutazione {

    @AuraEnabled
    public static void imposta(Id azienda,
            String valore) {
        Set<String> ammessi = new Set<String>();
        for (Schema.PicklistEntry voce : Account.Rating
                .getDescribe().getPicklistValues()) {
            ammessi.add(voce.getValue());
        }
        if (!ammessi.contains(valore)) {
            AuraHandledException e =
                new AuraHandledException('Non ammesso');
            e.setMessage('Valutazione non ammessa: '
                + valore);
            throw e;
        }
        update as user new Account(
            Id = azienda, Rating = valore);
    }
}
