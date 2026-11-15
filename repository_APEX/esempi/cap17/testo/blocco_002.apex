Account padre = new Account(
    Name = 'Prova Padre', BillingCountry = 'Prova');
insert padre;
Contact figlio = new Contact(
    LastName = 'Provetti', AccountId = padre.Id);
insert figlio;
System.debug([SELECT Account.Name FROM Contact
    WHERE Id = :figlio.Id].Account.Name);
