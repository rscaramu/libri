Account a = [SELECT Id FROM Account
    WHERE Name = 'Officine Riva' LIMIT 1];
a.BillingCity = 'Taranto';
update a;
System.debug([SELECT COUNT() FROM Contact
    WHERE AccountId = :a.Id
    AND MailingCity = 'Taranto']);
a.BillingCity = 'Bari';
update a;
