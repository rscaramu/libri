Opportunity grande = new Opportunity(
    Name = 'Prova gestore', StageName = 'Prospecting',
    CloseDate = Date.today().addDays(30),
    Amount = 150000);
insert grande;
System.debug([SELECT COUNT() FROM Task
    WHERE WhatId = :grande.Id]);
delete grande;
