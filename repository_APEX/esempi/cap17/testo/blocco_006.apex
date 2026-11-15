Account vittima = [SELECT Id FROM Account
    WHERE Name = 'Prova 5' LIMIT 1];
delete vittima;
System.debug([SELECT COUNT() FROM Account
    WHERE Name = 'Prova 5']);
List<Account> nelCestino = [SELECT Id FROM Account
    WHERE Name = 'Prova 5' AND IsDeleted = true
    ALL ROWS];
System.debug(nelCestino.size());
undelete nelCestino;
System.debug([SELECT COUNT() FROM Account
    WHERE Name = 'Prova 5']);
