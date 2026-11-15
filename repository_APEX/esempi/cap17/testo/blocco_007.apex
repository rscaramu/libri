Account principale = new Account(
    Name = 'Prova Doppia', BillingCountry = 'Prova');
Account doppione = new Account(
    Name = 'Prova Doppia Srl', BillingCountry = 'Prova');
insert new List<Account>{ principale, doppione };
insert new Contact(
    LastName = 'Trasferito', AccountId = doppione.Id);
merge principale doppione;
System.debug([SELECT COUNT() FROM Contact
    WHERE AccountId = :principale.Id]);
System.debug([SELECT COUNT() FROM Account
    WHERE Id = :doppione.Id]);
