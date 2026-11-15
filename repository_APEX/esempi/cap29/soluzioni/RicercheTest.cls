@IsTest
private class RicercheTest {

    @TestSetup
    static void prepara() {
        insert new List<Contact>{
            new Contact(LastName = 'Uno',
                Email = 'uno@test.example'),
            new Contact(LastName = 'Due',
                Email = 'due@test.example') };
    }

    @IsTest
    static void trovaIlContattoEsistente() {
        Contact c = Ricerche.perPosta('due@test.example');

        Assert.isNotNull(c);
        Assert.areEqual('Due', c.LastName);
    }

    @IsTest
    static void indirizzoInesistenteRestituisceNull() {
        Assert.isNull(
            Ricerche.perPosta('altro@test.example'));
    }

    @IsTest
    static void indirizzoVuotoRestituisceNull() {
        Assert.isNull(Ricerche.perPosta('  '));
        Assert.isNull(Ricerche.perPosta(null));
    }
}
