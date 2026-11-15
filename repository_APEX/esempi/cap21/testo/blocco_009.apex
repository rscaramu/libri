GestoreTrigger.sospendi('GestoreTrattative');
Opportunity silenziosa = new Opportunity(
    Name = 'Prova sospesa', StageName = 'Prospecting',
    CloseDate = Date.today().addDays(30),
    Amount = 150000);
insert silenziosa;
GestoreTrigger.riattiva('GestoreTrattative');
System.debug([SELECT COUNT() FROM Task
    WHERE WhatId = :silenziosa.Id]);
delete silenziosa;
