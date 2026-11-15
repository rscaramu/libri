List<Parametro__mdt> attivi = [
    SELECT DeveloperName, Numero__c
    FROM Parametro__mdt
    WHERE Attivo__c = true AND Numero__c != null
    ORDER BY DeveloperName
];
for (Parametro__mdt p : attivi) {
    System.debug(p.DeveloperName + ': ' + p.Numero__c);
}
