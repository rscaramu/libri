Opportunity grande = new Opportunity(
    Name = 'Prova rilevante', StageName = 'Prospecting',
    CloseDate = Date.today().addDays(30),
    Amount = 150000);
Opportunity piccola = grande.clone();
piccola.Name = 'Prova modesta';
piccola.Amount = 2000;
insert new List<Opportunity>{ grande, piccola };
System.debug([SELECT COUNT() FROM Task
    WHERE WhatId = :grande.Id]);
System.debug([SELECT COUNT() FROM Task
    WHERE WhatId = :piccola.Id]);
delete new List<Opportunity>{ grande, piccola };
