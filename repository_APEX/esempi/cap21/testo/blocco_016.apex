GestoreTrigger.sospendi('GestoreLead');
try {
    insert new Lead(Company = 'Senza cognome');
} catch (DmlException e) {
    System.debug('Inserimento respinto');
} finally {
    GestoreTrigger.riattiva('GestoreLead');
}
Lead l = new Lead(
    LastName = 'Dopo', Company = 'Prova');
insert l;
System.debug([SELECT Rating FROM Lead
    WHERE Id = :l.Id].Rating);
delete l;
