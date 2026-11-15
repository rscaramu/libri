try {
    insert new Opportunity(Name = 'Prova negativa',
        StageName = 'Prospecting',
        CloseDate = Date.today().addDays(10),
        Amount = -500);
} catch (DmlException e) {
    System.debug(e.getDmlType(0));
    System.debug(e.getDmlMessage(0));
}
