Contact c = new Contact(LastName = 'Prova Trigger',
    Email = 'P.Trigger@Esempio.IT');
insert c;
c = [SELECT Email, Title FROM Contact WHERE Id = :c.Id];
System.debug(c.Email);
System.debug(c.Title);
delete c;
