public with sharing class EsitoChiamata {

    public enum Tipo { RIUSCITA, DA_RIPROVARE, DEFINITIVO }

    public static Tipo classifica(HttpResponse risposta) {
        Integer stato = risposta.getStatusCode();
        if (stato >= 200 && stato < 300) {
            return Tipo.RIUSCITA;
        }
        if (stato == 429 || stato >= 500) {
            return Tipo.DA_RIPROVARE;
        }
        return Tipo.DEFINITIVO;
    }
}
