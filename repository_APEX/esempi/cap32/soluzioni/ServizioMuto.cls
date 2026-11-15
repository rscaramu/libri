@IsTest
public class ServizioMuto implements HttpCalloutMock {

    public HttpResponse respond(HttpRequest richiesta) {
        throw new CalloutException('Read timed out');
    }
}
