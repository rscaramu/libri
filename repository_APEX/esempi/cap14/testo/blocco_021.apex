Map<Id, Account> aziende = new Map<Id, Account>([
    SELECT Name FROM Account
    WHERE BillingCountry = 'Italia'
]);
Map<Id, Integer> conteggi = new Map<Id, Integer>();
for (Id chiave : aziende.keySet()) {
    conteggi.put(chiave, 0);
}
for (Contact c : [SELECT AccountId FROM Contact
        WHERE AccountId IN :aziende.keySet()]) {
    conteggi.put(c.AccountId,
        conteggi.get(c.AccountId) + 1);
}
List<String> righe = new List<String>();
for (Id chiave : aziende.keySet()) {
    righe.add(aziende.get(chiave).Name + ': '
        + conteggi.get(chiave));
}
righe.sort();
for (String riga : righe) {
    System.debug(riga);
}
