Account a = new Account(
    Name = 'Prova Transazione', BillingCountry = 'Prova');
insert a;
Savepoint punto = Database.setSavepoint();
try {
    insert new Contact(
        LastName = 'Provvisorio', AccountId = a.Id);
    insert new Contact(AccountId = a.Id);
} catch (DmlException e) {
    Database.rollback(punto);
    System.debug('Contatti annullati');
}
System.debug([SELECT COUNT() FROM Contact
    WHERE AccountId = :a.Id]);
System.debug([SELECT COUNT() FROM Account
    WHERE Id = :a.Id]);
delete a;
