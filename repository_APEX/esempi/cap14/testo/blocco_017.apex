List<Account> aziende = [SELECT Id FROM Account
    WHERE BillingCountry = 'Italia'];
for (Account a : aziende) {
    List<Contact> persone = [SELECT LastName
        FROM Contact WHERE AccountId = :a.Id];
    System.debug(persone.size());
}
