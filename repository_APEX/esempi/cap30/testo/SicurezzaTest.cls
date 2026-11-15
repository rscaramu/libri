@IsTest
private class SicurezzaTest {

    @IsTest
    static void utenteStandardVedeLeSueAziende() {
        User utente = FabbricaUtenti.standard();

        System.runAs(utente) {
            FabbricaDati.aziende(3);

            Assert.areEqual(3,
                ElencoAziende.italiane().size());
            Assert.areEqual(utente.Id,
                UserInfo.getUserId());
        }
    }
}
