Opportunity o = new Opportunity(
    Name = 'Prova vinta', StageName = 'Prospecting',
    CloseDate = Date.today(), Amount = 5000);
insert o;
o.StageName = 'Closed Won';
update o;
o.Amount = 6000;
update o;
System.debug([SELECT COUNT() FROM Task
    WHERE WhatId = :o.Id
    AND Subject = 'Ringraziare il cliente']);
delete o;
