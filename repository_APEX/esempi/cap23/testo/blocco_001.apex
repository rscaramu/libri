Parametro__mdt soglia =
    Parametro__mdt.getInstance('Soglia_Verifica');
System.debug(soglia.Numero__c);
System.debug(soglia.MasterLabel);
Map<String, Parametro__mdt> tutti =
    Parametro__mdt.getAll();
System.debug(tutti.size());
System.debug(Parametro__mdt.getInstance('Inesistente'));
System.debug(Limits.getQueries());
