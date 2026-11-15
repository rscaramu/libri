Account a = [SELECT Id, Rating FROM Account
    WHERE Name = 'Tecno Sud' LIMIT 1];
a.Rating = 'Hot';
update a;
a.Phone = '0832 555011';
update a;
System.debug([SELECT COUNT() FROM Task
    WHERE WhatId = :a.Id
    AND Subject LIKE 'Contattare%']);
a.Rating = 'Warm';
update a;
delete [SELECT Id FROM Task WHERE WhatId = :a.Id
    AND Subject LIKE 'Contattare%'];
