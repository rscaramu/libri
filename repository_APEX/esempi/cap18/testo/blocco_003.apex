Integer prima = Limits.getQueries();
List<Account> aziende = [SELECT Id FROM Account
    WHERE BillingCountry = 'Italia'];
List<Contact> persone = [SELECT Id FROM Contact
    WHERE MailingCountry = 'Italia'];
System.debug(Limits.getQueries() - prima);
System.debug(Limits.getLimitQueries());
System.debug(Limits.getQueryRows());
System.debug(Limits.getDmlStatements());
System.debug(Limits.getLimitDmlRows());
System.debug(Limits.getCpuTime() < Limits.getLimitCpuTime());
