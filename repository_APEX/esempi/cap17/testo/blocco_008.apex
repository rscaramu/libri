try {
    insert new Account(BillingCountry = 'Prova');
} catch (DmlException e) {
    System.debug(e.getNumDml());
    System.debug(e.getDmlType(0));
    System.debug(e.getDmlMessage(0));
    System.debug(e.getDmlFieldNames(0));
}
