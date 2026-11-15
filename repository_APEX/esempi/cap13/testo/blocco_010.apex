List<Contact> persone = new List<Contact>{
    new Contact(FirstName = 'Anna', LastName = 'Conti'),
    new Contact(FirstName = 'Luca', LastName = 'Riva'),
    new Contact(FirstName = 'Sara', LastName = 'Neri')
};
for (Contact c : persone) {
    System.debug(c.LastName + ', ' + c.FirstName);
}
