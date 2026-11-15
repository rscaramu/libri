List<Account> aziende = [SELECT Id FROM Account
    WHERE Name = 'Energia Blu'];
System.debug(ConteggiAziende.contaContatti(aziende)
    .values());
