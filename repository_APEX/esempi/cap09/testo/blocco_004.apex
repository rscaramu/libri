List<Pagabile> daPagare = new List<Pagabile>{
    new FatturaFornitore('2026/118', 1000),
    new NotaSpese('L. Conti', 184.50)
};
Decimal uscite = 0;
for (Pagabile voce : daPagare) {
    System.debug(voce.causale() + ': '
        + voce.importoDovuto());
    uscite += voce.importoDovuto();
}
System.debug(uscite);
