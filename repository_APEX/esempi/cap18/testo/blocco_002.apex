Account riservata = [SELECT Id, NumberOfEmployees
    FROM Account WHERE Name = 'Tecno Sud'
    LIMIT 1 FOR UPDATE];
riservata.NumberOfEmployees += 1;
update riservata;
riservata.NumberOfEmployees -= 1;
update riservata;
System.debug(riservata.NumberOfEmployees);
