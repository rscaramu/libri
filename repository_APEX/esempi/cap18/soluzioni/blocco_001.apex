List<Contact> prova = new List<Contact>();
for (Integer i = 0; i < 50; i++) {
    prova.add(new Contact(LastName = 'Limite ' + i));
}
System.debug(Limits.getDmlStatements() + ' - '
    + Limits.getDmlRows());
insert prova;
delete prova;
System.debug(Limits.getDmlStatements() + ' - '
    + Limits.getDmlRows());
