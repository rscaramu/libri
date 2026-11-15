String termine = 'Tec*';
List<List<sObject>> esiti = [
    FIND :termine
    IN NAME FIELDS
    RETURNING Account(Name, BillingCity
        WHERE BillingCountry = 'Italia'
        ORDER BY Name LIMIT 5)
];
for (Account a : (List<Account>) esiti[0]) {
    System.debug(a.Name + ' - ' + a.BillingCity);
}
