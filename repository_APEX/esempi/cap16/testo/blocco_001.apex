List<List<sObject>> esiti = [
    FIND 'Riva'
    IN NAME FIELDS
    RETURNING Account(Name), Contact(FirstName, LastName)
];
List<Account> aziende = (List<Account>) esiti[0];
List<Contact> persone = (List<Contact>) esiti[1];
for (Account a : aziende) {
    System.debug('Azienda: ' + a.Name);
}
for (Contact c : persone) {
    System.debug('Persona: ' + c.FirstName + ' '
        + c.LastName);
}
