public with sharing class LavoroCambiConRipresa
        implements Queueable, Database.AllowsCallouts {

    private Integer tentativo;

    public LavoroCambiConRipresa(Integer tentativo) {
        this.tentativo = tentativo;
    }

    public void execute(QueueableContext contesto) {
        try {
            ClienteCambi.Listino listino =
                new ClienteCambi().leggi('EUR');
            System.debug('Tassi letti: '
                + listino.tassi.size());
        } catch (ClienteCambi.CambiException e) {
            if (tentativo >= 3) {
                Diario.errore('LavoroCambiConRipresa', e);
                return;
            }
            System.enqueueJob(
                new LavoroCambiConRipresa(tentativo + 1),
                Ripetizioni.minutiDiAttesa(tentativo));
        }
    }
}
