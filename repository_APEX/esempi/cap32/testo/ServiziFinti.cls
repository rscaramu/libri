@IsTest
public class ServiziFinti implements HttpCalloutMock {

    private Map<String, String> risposte;

    public ServiziFinti(Map<String, String> risposte) {
        this.risposte = risposte;
    }

    public HttpResponse respond(HttpRequest richiesta) {
        HttpResponse risposta = new HttpResponse();
        for (String frammento : risposte.keySet()) {
            if (richiesta.getEndpoint()
                    .contains(frammento)) {
                risposta.setStatusCode(200);
                risposta.setBody(risposte.get(frammento));
                return risposta;
            }
        }
        risposta.setStatusCode(404);
        risposta.setBody('{}');
        return risposta;
    }
}
