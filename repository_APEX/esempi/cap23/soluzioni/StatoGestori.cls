public with sharing class StatoGestori {

    public static Boolean abilitato(String gestore) {
        if (Esenzioni.saltaControlli()) {
            return false;
        }
        return Parametri2.attivo(gestore);
    }
}
