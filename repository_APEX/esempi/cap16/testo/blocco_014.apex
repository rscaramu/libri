List<List<sObject>> esiti = [
    FIND 'Neri'
    IN ALL FIELDS
    RETURNING Account(Name), Contact(LastName)
];
System.debug('Aziende: ' + esiti[0].size());
System.debug('Persone: ' + esiti[1].size());
