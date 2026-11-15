@IsTest
private class AggiornaTelefonoTest {

    @IsTest
    static void ilTitolareAggiornaLaSuaAzienda() {
        User utente = FabbricaUtenti.standard();

        System.runAs(utente) {
            Account azienda = FabbricaDati.aziende(1)[0];

            String esito = AggiornaTelefono.esegui(
                azienda.Id, '0965 111222');

            Assert.areEqual('Telefono aggiornato', esito);
            Assert.areEqual('0965 111222',
                [SELECT Phone FROM Account
                    WHERE Id = :azienda.Id].Phone);
        }
    }
}
