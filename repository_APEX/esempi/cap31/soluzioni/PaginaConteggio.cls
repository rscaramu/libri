public with sharing class PaginaConteggio {

    public String citta { get; set; }
    public Integer quante { get; private set; }

    public PaginaConteggio() {
        quante = 0;
    }

    public PageReference conta() {
        quante = [SELECT COUNT() FROM Account
            WHERE BillingCountry = 'Italia'
            AND BillingCity = :citta
            WITH USER_MODE];
        return null;
    }
}
