public with sharing class ClienteCambi {

    public class CambiException extends Exception {}

    public class Listino {
        public String base;
        public String data;
        public Map<String, Decimal> tassi;
    }

    public Listino leggi(String valutaBase) {
        HttpRequest richiesta = new HttpRequest();
        richiesta.setEndpoint('callout:Servizio_Cambi'
            + '/cambi?base='
            + EncodingUtil.urlEncode(valutaBase, 'UTF-8'));
        richiesta.setMethod('GET');
        richiesta.setHeader('Accept', 'application/json');
        richiesta.setTimeout(20000);
        HttpResponse risposta;
        try {
            risposta = new Http().send(richiesta);
        } catch (CalloutException e) {
            throw new CambiException(
                'Servizio non raggiungibile', e);
        }
        if (risposta.getStatusCode() != 200) {
            throw new CambiException('Risposta '
                + risposta.getStatusCode());
        }
        try {
            return (Listino) JSON.deserialize(
                risposta.getBody(), Listino.class);
        } catch (JSONException e) {
            throw new CambiException(
                'Risposta non interpretabile', e);
        }
    }
}
