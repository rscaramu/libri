@IsTest
private class RicercaTestualeTest {

    @IsTest
    static void laRicercaRestituisceIRecordIndicati() {
        List<Account> aziende = FabbricaDati.aziende(2);
        Test.setFixedSearchResults(
            new List<Id>{ aziende[0].Id });

        List<List<sObject>> esiti = [
            FIND 'Azienda' IN NAME FIELDS
            RETURNING Account(Name)];

        Assert.areEqual(1, esiti[0].size());
    }
}
