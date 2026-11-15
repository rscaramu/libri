Id azienda = [SELECT Id FROM Account
    WHERE Name = 'Officine Riva' LIMIT 1].Id;
System.debug(ControllerContatti.diAzienda(azienda)
    .size());
System.debug(ControllerContatti.diAzienda(null).size());
