public with sharing class VerificaAzienda {

    @future(callout=true)
    public static void controlla(Id azienda) {
        Account a = [SELECT Id, Name FROM Account
            WHERE Id = :azienda];
        // Qui la chiamata al servizio esterno,
        // argomento del Capitolo 32.
        a.Description = 'Verifica richiesta il '
            + Datetime.now().format('dd/MM/yyyy HH:mm');
        update a;
    }
}
