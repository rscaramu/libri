List<Contact> lista = new List<Contact>{
    new Contact(LastName = 'Importato Uno'),
    new Contact(FirstName = 'Senza cognome'),
    new Contact(LastName = 'Importato Due')
};
System.debug(Importazione.contatti(lista));
delete [SELECT Id FROM Contact
    WHERE LastName LIKE 'Importato%'];
