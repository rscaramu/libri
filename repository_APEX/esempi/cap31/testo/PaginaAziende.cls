public with sharing class PaginaAziende {

    public String filtro { get; set; }
    public List<Account> aziende { get; private set; }

    public PaginaAziende() {
        filtro = '';
        cerca();
    }

    public PageReference cerca() {
        String modello = '%' + filtro + '%';
        aziende = [
            SELECT Name, BillingCity FROM Account
            WHERE BillingCountry = 'Italia'
                AND Name LIKE :modello
            WITH USER_MODE
            ORDER BY Name LIMIT 100
        ];
        if (aziende.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.INFO,
                'Nessuna azienda trovata'));
        }
        return null;
    }
}
