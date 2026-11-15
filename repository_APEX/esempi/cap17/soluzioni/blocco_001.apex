Account a = new Account(
    Name = 'Prova Diciassette', BillingCountry = 'Prova');
insert a;
List<Opportunity> affari = new List<Opportunity>();
for (Integer i = 1; i <= 3; i++) {
    affari.add(new Opportunity(Name = 'Affare ' + i,
        AccountId = a.Id, StageName = 'Prospecting',
        CloseDate = Date.today().addDays(30),
        Amount = 1000 * i));
}
insert affari;
AggregateResult r = [SELECT SUM(Amount) tot
    FROM Opportunity WHERE AccountId = :a.Id];
System.debug(((Decimal) r.get('tot')).setScale(0));
delete a;
