@IsTest
private class ClienteSpedizioniTest {

    @IsTest
    static void prenotaERestituisceIlCodice() {
        Test.setMock(HttpCalloutMock.class,
            new ServizioFinto(201,
                '{"codice":"SP-77","stato":"PRENOTATA"}'));
        ClienteSpedizioni.Richiesta dati =
            new ClienteSpedizioni.Richiesta();
        dati.destinatario = 'Tecno Sud';
        dati.citta = 'Lecce';
        dati.pesoKg = 12.5;

        Test.startTest();
        ClienteSpedizioni.Esito esito =
            new ClienteSpedizioni().prenota(dati);
        Test.stopTest();

        Assert.areEqual('SP-77', esito.codice);
        Assert.areEqual('PRENOTATA', esito.stato);
    }
}
