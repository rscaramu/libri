Account azienda = new Account(Name = 'Tecno Sud');
insert azienda;
Contact persona = new Contact(
    FirstName = 'Anna',
    LastName = 'Conti',
    AccountId = azienda.Id);
insert persona;
System.debug(persona.AccountId == azienda.Id);
