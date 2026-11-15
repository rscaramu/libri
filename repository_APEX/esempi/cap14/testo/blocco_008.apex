String citta = 'Bari';
Decimal soglia = 1000000;
List<Account> trovate = [
    SELECT Name FROM Account
    WHERE BillingCity = :citta
        AND AnnualRevenue >= :soglia
];
System.debug(trovate.size());
System.debug(trovate[0].Name);
