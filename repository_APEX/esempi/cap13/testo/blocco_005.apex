List<sObject> misti = new List<sObject>{
    new Account(Name = 'Alfa'),
    new Contact(LastName = 'Bassi'),
    new Lead(LastName = 'Corsi', Company = 'Delta')
};
for (sObject record : misti) {
    System.debug(record.getSObjectType());
}
sObject generico = misti[0];
generico.put('Phone', '02 555111');
System.debug(generico.get('Name'));
System.debug(generico.get('Phone'));
Account tipizzato = (Account) generico;
System.debug(tipizzato.Phone);
