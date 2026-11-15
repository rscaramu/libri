Map<String, Object> valori = new Map<String, Object>{
    'citta' => 'Bari',
    'soglia' => 1000000
};
List<Account> esito = Database.queryWithBinds(
    'SELECT Name FROM Account'
    + ' WHERE BillingCity = :citta'
    + ' AND AnnualRevenue > :soglia',
    valori, AccessLevel.SYSTEM_MODE);
System.debug(esito[0].Name);
