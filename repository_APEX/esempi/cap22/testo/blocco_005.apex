Case c = new Case(Subject = 'Prova ricorsione');
insert c;
c.Priority = 'High';
update c;
System.debug(GestoreCasi.esecuzioni);
delete c;
