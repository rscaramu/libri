public with sharing class ServizioAziende {

    public static void avvisaTitolari(
            List<Account> aziende) {
        List<Task> attivita = new List<Task>();
        for (Account a : aziende) {
            attivita.add(new Task(
                Subject = 'Contattare cliente promettente',
                WhatId = a.Id, OwnerId = a.OwnerId));
        }
        insert attivita;
    }
}
