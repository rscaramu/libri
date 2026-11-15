Savepoint punto = Database.setSavepoint();
try {
    insert new Account(Name = 'Prova Diario',
        BillingCountry = 'Prova');
    Integer x = 1 / 0;
} catch (Exception e) {
    Database.rollback(punto);
    Diario.errore('Blocco di prova', e);
}
System.debug([SELECT COUNT() FROM Account
    WHERE Name = 'Prova Diario']);
