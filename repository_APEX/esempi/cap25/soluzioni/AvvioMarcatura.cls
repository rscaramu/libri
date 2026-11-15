public with sharing class AvvioMarcatura {

    public static Boolean avvia(List<Id> contatti) {
        if (contatti == null || contatti.isEmpty()
                || Limits.getFutureCalls()
                    >= Limits.getLimitFutureCalls()) {
            return false;
        }
        MarcaturaContatti.marca(contatti);
        return true;
    }
}
