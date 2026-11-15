Account a = new Account(Name = 'Prova Tredici');
insert a;
insert new List<Contact>{
    new Contact(LastName = 'Primo', AccountId = a.Id),
    new Contact(LastName = 'Secondo', AccountId = a.Id) };
