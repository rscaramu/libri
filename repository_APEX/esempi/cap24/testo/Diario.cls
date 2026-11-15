public with sharing class Diario {

    public static void errore(String origine, Exception e) {
        EventBus.publish(new Errore_Applicazione__e(
            Origine__c = origine.left(80),
            Messaggio__c = (e.getTypeName() + ': '
                + e.getMessage()).left(255)));
    }
}
