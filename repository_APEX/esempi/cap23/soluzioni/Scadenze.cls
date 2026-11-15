public with sharing class Scadenze {

    public static Date calcola(Date emissione) {
        Integer giorni = Parametri2.numero(
            'Giorni_Scadenza', 60).intValue();
        return emissione.addDays(giorni);
    }
}
