public with sharing class RichiesteCambi {

    public static HttpRequest componi(String base,
            String simboli) {
        HttpRequest richiesta = new HttpRequest();
        richiesta.setEndpoint('callout:Servizio_Cambi/cambi'
            + '?base='
            + EncodingUtil.urlEncode(base, 'UTF-8')
            + '&simboli='
            + EncodingUtil.urlEncode(simboli, 'UTF-8'));
        richiesta.setMethod('GET');
        return richiesta;
    }
}
