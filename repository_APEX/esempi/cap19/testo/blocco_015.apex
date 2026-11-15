Id azienda = [SELECT Id FROM Account
    WHERE Name = 'Tecno Sud' LIMIT 1].Id;
System.debug(AggiornaTelefono.esegui(
    azienda, '0832 555010'));
