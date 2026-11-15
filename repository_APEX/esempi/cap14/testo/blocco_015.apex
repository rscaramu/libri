for (List<Contact> gruppo : [SELECT LastName
        FROM Contact
        WHERE MailingCountry = 'Italia']) {
    System.debug(gruppo.size());
}
