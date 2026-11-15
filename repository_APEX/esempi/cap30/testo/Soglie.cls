public with sharing class Soglie {

    @TestVisible
    private static Decimal forzata;

    public static Decimal verifica() {
        return forzata
            ?? Parametri2.numero('Soglia_Verifica', 100000);
    }
}
