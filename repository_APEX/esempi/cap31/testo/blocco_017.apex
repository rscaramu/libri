Id azienda = [SELECT Id FROM Account
    WHERE Name = 'Tecno Sud' LIMIT 1].Id;
try {
    ControllerValutazione.imposta(azienda, 'Bollente');
} catch (AuraHandledException e) {
    System.debug(e.getMessage());
}
ControllerValutazione.imposta(azienda, 'Warm');
System.debug([SELECT Rating FROM Account
    WHERE Id = :azienda].Rating);
