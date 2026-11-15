public with sharing class ControllerAziende {

    @AuraEnabled(cacheable=true)
    public static List<Account> italiane() {
        return [
            SELECT Id, Name, BillingCity, AnnualRevenue
            FROM Account
            WHERE BillingCountry = 'Italia'
            WITH USER_MODE
            ORDER BY Name
            LIMIT 50
        ];
    }

    @AuraEnabled
    public static Id creaAttivita(Id azienda,
            String oggetto) {
        Task t = new Task(Subject = oggetto,
            WhatId = azienda);
        insert as user t;
        return t.Id;
    }
}
