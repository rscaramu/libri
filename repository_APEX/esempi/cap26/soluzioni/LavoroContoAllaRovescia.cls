public with sharing class LavoroContoAllaRovescia
        implements Queueable {

    private Integer n;

    public LavoroContoAllaRovescia(Integer n) {
        this.n = n;
    }

    public void execute(QueueableContext contesto) {
        System.debug('Valore: ' + n);
        if (n > 1) {
            System.enqueueJob(
                new LavoroContoAllaRovescia(n - 1));
        }
    }
}
