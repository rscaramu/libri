for (Account a : RicercaAziende.cerca(
        null, 1000000, 'AnnualRevenue')) {
    System.debug(a.Name);
}
System.debug(RicercaAziende.cerca(
    'Bari', null, 'DROP').size());
