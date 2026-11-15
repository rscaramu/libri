public abstract class Notifica {

    protected abstract String canale();

    public void invia(String messaggio) {
        System.debug('[' + canale() + '] ' + messaggio);
    }
}
