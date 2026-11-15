Account esistente = [SELECT Id FROM Account
    WHERE Name = 'Prova 2' LIMIT 1];
esistente.Phone = '0965 000222';
Account nuovo = new Account(
    Name = 'Prova 5', BillingCountry = 'Prova');
List<Account> misti = new List<Account>{
    esistente, nuovo };
upsert misti;
System.debug([SELECT COUNT() FROM Account
    WHERE BillingCountry = 'Prova'
    AND Name LIKE 'Prova _']);
