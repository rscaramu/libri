@IsTest
private class NominativiTest {

    @IsTest
    static void restituisceLeInizialiMaiuscole() {
        Assert.areEqual('M.R.',
            Nominativi.iniziali('maria', 'rossi'));
    }

    @IsTest
    static void ignoraGliSpaziIniziali() {
        Assert.areEqual('A.B.',
            Nominativi.iniziali('  anna', ' bianchi '));
    }

    @IsTest
    static void conValoreAssenteRestituisceVuoto() {
        Assert.areEqual('',
            Nominativi.iniziali(null, 'rossi'));
        Assert.areEqual('',
            Nominativi.iniziali('maria', '   '));
    }
}
