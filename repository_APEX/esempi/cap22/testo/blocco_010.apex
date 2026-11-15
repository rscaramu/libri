Case c = new Case(Subject = 'Prova senza ricorsione');
insert c;
c.Priority = 'High';
update c;
System.debug(GestoreCasi2.esecuzioni);
System.debug([SELECT Description FROM Case
    WHERE Id = :c.Id].Description);
delete c;
