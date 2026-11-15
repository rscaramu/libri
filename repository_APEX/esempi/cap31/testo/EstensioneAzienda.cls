public with sharing class EstensioneAzienda {

    private Account azienda;

    public EstensioneAzienda(
            ApexPages.StandardController standard) {
        azienda = (Account) standard.getRecord();
    }

    public Integer getNumeroContatti() {
        return [SELECT COUNT() FROM Contact
            WHERE AccountId = :azienda.Id];
    }
}
