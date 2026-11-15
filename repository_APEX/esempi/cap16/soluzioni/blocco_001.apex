List<List<sObject>> esiti = [
    FIND 'esempio.it' IN EMAIL FIELDS
    RETURNING Contact(FirstName, LastName
        ORDER BY LastName)];
for (Contact c : (List<Contact>) esiti[0]) {
    System.debug(c.FirstName + ' ' + c.LastName);
}
