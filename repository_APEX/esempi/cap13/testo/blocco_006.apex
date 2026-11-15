sObject record = new Contact(LastName = 'Bassi');
switch on record {
    when Account a {
        System.debug('Azienda: ' + a.Name);
    }
    when Contact c {
        System.debug('Persona: ' + c.LastName);
    }
    when else {
        System.debug('Altro');
    }
}
