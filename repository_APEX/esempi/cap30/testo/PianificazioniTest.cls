@IsTest
private class PianificazioniTest {

    @IsTest
    static void attivaCreaDuePianificazioni() {
        Test.startTest();
        Pianificazioni.attiva();
        Test.stopTest();

        Assert.areEqual(2, [SELECT COUNT()
            FROM CronTrigger
            WHERE CronJobDetail.Name LIKE 'APP %']);
    }

    @IsTest
    static void ilPromemoriaNonDuplicaLeAttivita() {
        Account azienda = FabbricaDati.aziende(1)[0];
        Opportunity o =
            FabbricaDati.trattativa(azienda, 1000);
        o.CloseDate = Date.today().addDays(3);
        update o;
        PromemoriaUnici promemoria = new PromemoriaUnici();

        promemoria.execute(null);
        promemoria.execute(null);

        Assert.areEqual(1, [SELECT COUNT() FROM Task
            WHERE Subject LIKE 'In scadenza:%']);
    }
}
