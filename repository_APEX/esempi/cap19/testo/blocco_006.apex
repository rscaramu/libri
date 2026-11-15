Account a = new Account(
    Name = 'Prova Sicura', BillingCountry = 'Prova');
insert as user a;
a.Phone = '0965 000333';
update as user a;
delete as user a;
System.debug([SELECT COUNT() FROM Account
    WHERE BillingCountry = 'Prova']);
