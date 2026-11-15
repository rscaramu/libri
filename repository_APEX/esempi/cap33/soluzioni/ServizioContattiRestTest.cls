@IsTest
private class ServizioContattiRestTest {

    private static void preparaContesto() {
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
    }

    @IsTest
    static void creaIlContattoERisponde201() {
        Account azienda = FabbricaDati.aziende(1)[0];
        preparaContesto();

        ServizioContattiRest.Esito esito =
            ServizioContattiRest.crea('Bruno', 'Ferri',
                'bruno@test.example', azienda.Id);

        Assert.isTrue(esito.riuscito);
        Assert.areEqual(201,
            RestContext.response.statusCode);
    }

    @IsTest
    static void senzaCognomeRisponde400() {
        preparaContesto();

        ServizioContattiRest.Esito esito =
            ServizioContattiRest.crea(
                'Bruno', '', null, null);

        Assert.isFalse(esito.riuscito);
        Assert.areEqual(400,
            RestContext.response.statusCode);
    }
}
