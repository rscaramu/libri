public with sharing class Diario2 {

    public static void avviso(String origine,
            String testo) {
        EventBus.publish(new Errore_Applicazione__e(
            Origine__c = (origine ?? '').left(80),
            Messaggio__c = (testo ?? '').left(255)));
    }
}
