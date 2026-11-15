List<Id> chiavi = new List<Id>();
for (Account a : [SELECT Id FROM Account
        WHERE Name IN ('Energia Blu', 'Agricola Verde')
        ORDER BY Name]) {
    chiavi.add(a.Id);
}
System.debug(AzioneTrattativeAperte.conta(chiavi));
