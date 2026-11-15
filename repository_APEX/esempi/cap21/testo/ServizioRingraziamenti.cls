public with sharing class ServizioRingraziamenti {

    public static void crea(List<Opportunity> vinte) {
        List<Task> attivita = new List<Task>();
        for (Opportunity o : vinte) {
            attivita.add(new Task(
                Subject = 'Ringraziare il cliente',
                WhatId = o.Id, OwnerId = o.OwnerId));
        }
        insert attivita;
    }
}
