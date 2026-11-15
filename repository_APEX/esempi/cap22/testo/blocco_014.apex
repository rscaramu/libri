Set<Id> chiavi = new Map<Id, Account>([
    SELECT Id FROM Account
    WHERE BillingCity = 'Bari'
    AND BillingCountry = 'Italia']).keySet();
System.debug(ServizioValutazioni.imposta(chiavi, 'Hot'));
System.debug(ServizioValutazioni.imposta(chiavi, 'Hot'));
update new Account(Id = [SELECT Id FROM Account
    WHERE Name = 'Agricola Verde'].Id, Rating = null);
