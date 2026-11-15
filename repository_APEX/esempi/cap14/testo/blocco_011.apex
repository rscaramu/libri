try {
    Account nessuna = [SELECT Name FROM Account
        WHERE Name = 'Inesistente'];
} catch (QueryException e) {
    System.debug(e.getMessage());
}
try {
    Account troppe = [SELECT Name FROM Account
        WHERE BillingCity = 'Bari'];
} catch (QueryException e) {
    System.debug(e.getMessage());
}
