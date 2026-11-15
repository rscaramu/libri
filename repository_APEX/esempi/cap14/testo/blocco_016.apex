Map<Id, Account> perId = new Map<Id, Account>([
    SELECT Name FROM Account
    WHERE BillingCountry = 'Italia'
]);
System.debug(perId.size());
Id prima = new List<Id>(perId.keySet())[0];
System.debug(perId.get(prima).Name != null);
