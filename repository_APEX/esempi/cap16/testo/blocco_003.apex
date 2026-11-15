String campo = 'BillingCity';
String testo = 'SELECT Name, ' + campo
    + ' FROM Account'
    + ' WHERE BillingCountry = \'Italia\''
    + ' ORDER BY Name LIMIT 2';
List<sObject> esito = Database.query(testo);
for (sObject record : esito) {
    System.debug(record.get('Name') + ' - '
        + record.get(campo));
}
