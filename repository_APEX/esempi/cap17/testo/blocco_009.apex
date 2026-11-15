List<Account> lotto = new List<Account>{
    new Account(Name = 'Prova A', BillingCountry = 'Prova'),
    new Account(BillingCountry = 'Prova'),
    new Account(Name = 'Prova C', BillingCountry = 'Prova')
};
try {
    insert lotto;
} catch (DmlException e) {
    System.debug('Respinto il record '
        + e.getDmlIndex(0));
}
System.debug([SELECT COUNT() FROM Account
    WHERE Name IN ('Prova A', 'Prova C')]);
