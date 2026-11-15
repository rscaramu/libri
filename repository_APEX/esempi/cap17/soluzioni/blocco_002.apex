List<Contact> persone = [SELECT Id FROM Contact
    WHERE MailingCountry = 'Italia'];
String nota = 'Verificato il '
    + Datetime.now().format('dd/MM/yyyy');
for (Contact c : persone) {
    c.Description = nota;
}
update persone;
