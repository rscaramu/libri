Account singolo = new Account(
    Name = 'Prova Uno', BillingCountry = 'Prova');
insert singolo;
System.debug(singolo.Id != null);
List<Account> gruppo = new List<Account>();
for (Integer i = 2; i <= 4; i++) {
    gruppo.add(new Account(
        Name = 'Prova ' + i, BillingCountry = 'Prova'));
}
insert gruppo;
System.debug([SELECT COUNT() FROM Account
    WHERE BillingCountry = 'Prova']);
