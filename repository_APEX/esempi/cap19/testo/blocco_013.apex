Id azienda = [SELECT Id FROM Account
    WHERE Name = 'Energia Blu' LIMIT 1].Id;
for (Contact c : ContattiAzienda.elenco(azienda)) {
    System.debug(c.LastName);
}
