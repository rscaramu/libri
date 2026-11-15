List<Account> lette = Database.query(
    'SELECT Name FROM Account'
    + ' WHERE BillingCountry = \'Italia\'',
    AccessLevel.USER_MODE);
System.debug(lette.size());
Account b = new Account(
    Name = 'Prova Due', BillingCountry = 'Prova');
Database.SaveResult esito =
    Database.insert(b, AccessLevel.USER_MODE);
System.debug(esito.isSuccess());
Database.delete(b, AccessLevel.USER_MODE);
