Integer presenti = [SELECT COUNT() FROM Account
    WHERE BillingCountry = 'Italia'];
if (presenti == 0) {
    DatiDiProva.crea();
    System.debug('Dati di prova creati');
} else {
    System.debug('Dati gia\' presenti: ' + presenti);
}
