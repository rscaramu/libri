public with sharing class ChiamataSemplice {

    public static String leggi(String indirizzo) {
        HttpRequest richiesta = new HttpRequest();
        richiesta.setEndpoint(indirizzo);
        richiesta.setMethod('GET');
        richiesta.setHeader('Accept', 'application/json');
        richiesta.setTimeout(10000);
        HttpResponse risposta = new Http().send(richiesta);
        System.debug(risposta.getStatusCode() + ' '
            + risposta.getStatus());
        return risposta.getBody();
    }
}
