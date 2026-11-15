List<Opportunity> lotto = new List<Opportunity>();
for (Integer i = 0; i < 5; i++) {
    lotto.add(new Opportunity(Name = 'Parziale ' + i,
        StageName = 'Prospecting',
        CloseDate = i < 3 ? Date.today() : null));
}
List<Database.SaveResult> esiti =
    Database.insert(lotto, false);
for (Integer i = 0; i < esiti.size(); i++) {
    System.debug(i + ': ' + (esiti[i].isSuccess()
        ? 'salvata'
        : String.valueOf(
            esiti[i].getErrors()[0].getStatusCode())));
}
delete [SELECT Id FROM Opportunity
    WHERE Name LIKE 'Parziale%'];
