public with sharing class ClienteSpedizioni {

    public class Richiesta {
        public String destinatario;
        public String citta;
        public Decimal pesoKg;
    }

    public class Esito {
        public String codice;
        public String stato;
    }

    public Esito prenota(Richiesta dati) {
        HttpRequest richiesta = new HttpRequest();
        richiesta.setEndpoint(
            'callout:Servizio_Spedizioni/spedizioni');
        richiesta.setMethod('POST');
        richiesta.setHeader('Content-Type',
            'application/json');
        richiesta.setHeader('Idempotency-Key',
            UUID.randomUUID().toString());
        richiesta.setBody(JSON.serialize(dati));
        HttpResponse risposta = new Http().send(richiesta);
        if (risposta.getStatusCode() != 201) {
            throw new CalloutException('Prenotazione '
                + 'rifiutata: ' + risposta.getStatusCode());
        }
        return (Esito) JSON.deserialize(
            risposta.getBody(), Esito.class);
    }
}
