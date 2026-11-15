List<Account> daAggiornare = [
    SELECT Id, Name, Rating FROM Account
    WHERE BillingCountry = 'Prova'
        AND Name LIKE 'Prova _'
];
for (Account a : daAggiornare) {
    a.Rating = 'Warm';
    a.Description = 'Aggiornato dal manuale';
}
update daAggiornare;
System.debug([SELECT COUNT() FROM Account
    WHERE BillingCountry = 'Prova'
    AND Rating = 'Warm']);
