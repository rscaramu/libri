Contact c = new Contact(LastName = 'Cestinato');
insert c;
delete c;
System.debug([SELECT COUNT() FROM Contact
    WHERE Id = :c.Id AND IsDeleted = true ALL ROWS]);
undelete c;
System.debug([SELECT COUNT() FROM Contact
    WHERE Id = :c.Id]);
delete c;
