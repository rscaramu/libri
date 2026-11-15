System.debug(Creazione.aziendaConContatti(
    'Prova Buona', new List<String>{ 'Uno', 'Due' }));
System.debug(Creazione.aziendaConContatti(
    'Prova Guasta', new List<String>{ 'Tre', null }));
System.debug([SELECT COUNT() FROM Account
    WHERE BillingCountry = 'Prova']);
delete [SELECT Id FROM Account
    WHERE BillingCountry = 'Prova'];
