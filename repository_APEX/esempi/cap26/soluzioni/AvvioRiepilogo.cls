public with sharing class AvvioRiepilogo {

    public static Boolean avviaUnaVolta(Set<Id> aziende) {
        AsyncOptions opzioni = new AsyncOptions();
        opzioni.DuplicateSignature =
            QueueableDuplicateSignature.Builder()
                .addString('riepilogo-contatti')
                .build();
        try {
            System.enqueueJob(
                new LavoroRiepilogo(aziende), opzioni);
            return true;
        } catch (DuplicateMessageException e) {
            return false;
        }
    }
}
