@IsTest
public class ServizioFinto implements HttpCalloutMock {

    private Integer stato;
    private String corpo;

    public ServizioFinto(Integer stato, String corpo) {
        this.stato = stato;
        this.corpo = corpo;
    }

    public HttpResponse respond(HttpRequest richiesta) {
        HttpResponse risposta = new HttpResponse();
        risposta.setStatusCode(stato);
        risposta.setHeader('Content-Type',
            'application/json');
        risposta.setBody(corpo);
        return risposta;
    }
}
