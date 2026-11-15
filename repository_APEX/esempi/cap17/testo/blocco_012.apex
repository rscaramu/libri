Id azienda = [SELECT Id FROM Account
    WHERE Name = 'Tecno Sud' LIMIT 1].Id;
List<Contact> nuovi = new List<Contact>();
for (Integer i = 1; i <= 10; i++) {
    nuovi.add(new Contact(
        LastName = 'Collaudo ' + i,
        AccountId = azienda));
}
insert nuovi;
System.debug([SELECT COUNT() FROM Contact
    WHERE LastName LIKE 'Collaudo%']);
delete nuovi;
System.debug([SELECT COUNT() FROM Contact
    WHERE LastName LIKE 'Collaudo%']);
