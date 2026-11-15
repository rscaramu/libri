List<Account> lotto = new List<Account>{
    new Account(Name = 'Prova A', BillingCountry = 'Prova'),
    new Account(BillingCountry = 'Prova'),
    new Account(Name = 'Prova C', BillingCountry = 'Prova')
};
List<Database.SaveResult> esiti =
    Database.insert(lotto, false);
for (Integer i = 0; i < esiti.size(); i++) {
    Database.SaveResult esito = esiti[i];
    if (esito.isSuccess()) {
        System.debug(i + ': salvato');
    } else {
        Database.Error errore = esito.getErrors()[0];
        System.debug(i + ': ' + errore.getStatusCode()
            + ' ' + errore.getFields());
    }
}
