Map<String, Decimal> perFase = new Map<String, Decimal>();
for (Opportunity o : [SELECT StageName, Amount
        FROM Opportunity
        WHERE Account.BillingCountry = 'Italia']) {
    Decimal finora = perFase.containsKey(o.StageName)
        ? perFase.get(o.StageName) : 0;
    perFase.put(o.StageName, finora + (o.Amount ?? 0));
}
System.debug(perFase.get('Closed Won'));
