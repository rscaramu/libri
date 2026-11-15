PromemoriaUnici p = new PromemoriaUnici();
p.execute(null);
p.execute(null);
Integer quante = [SELECT COUNT() FROM Task
    WHERE Subject LIKE 'In scadenza:%'
    AND ActivityDate = TODAY];
System.debug(quante);
delete [SELECT Id FROM Task
    WHERE Subject LIKE 'In scadenza:%'];
