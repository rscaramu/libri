public with sharing class ServizioTrattative {

    public static final Decimal SOGLIA = 100000;

    public static void creaVerifiche(
            List<Opportunity> trattative) {
        List<Task> attivita = new List<Task>();
        for (Opportunity o : trattative) {
            if (o.Amount != null && o.Amount >= SOGLIA) {
                attivita.add(new Task(
                    Subject = 'Verifica trattativa rilevante',
                    WhatId = o.Id, OwnerId = o.OwnerId,
                    ActivityDate =
                        Date.today().addDays(3)));
            }
        }
        insert attivita;
    }
}
