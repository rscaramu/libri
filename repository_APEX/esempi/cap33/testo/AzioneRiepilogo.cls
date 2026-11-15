public with sharing class AzioneRiepilogo {

    @InvocableMethod(
        label='Aggiorna riepilogo contatti'
        description='Scrive il numero dei contatti.'
        category='Aziende')
    public static void esegui(List<Id> aziende) {
        Riepilogo.aggiorna([SELECT Id FROM Account
            WHERE Id IN :aziende]);
    }
}
