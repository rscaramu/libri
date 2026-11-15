public with sharing class LavoroCambio
        implements Queueable, Database.AllowsCallouts {

    private Set<Id> trattative;

    public LavoroCambio(Set<Id> trattative) {
        this.trattative = trattative;
    }

    public void execute(QueueableContext contesto) {
        ClienteCambi.Listino listino;
        try {
            listino = new ClienteCambi().leggi('EUR');
        } catch (ClienteCambi.CambiException e) {
            Diario.errore('LavoroCambio', e);
            return;
        }
        Decimal dollaro = listino.tassi.get('USD');
        List<Opportunity> daScrivere =
            new List<Opportunity>();
        for (Opportunity o : [SELECT Id, Amount
                FROM Opportunity
                WHERE Id IN :trattative]) {
            if (o.Amount != null && dollaro != null) {
                o.Description = 'Controvalore: '
                    + (o.Amount * dollaro).setScale(2)
                    + ' USD';
                daScrivere.add(o);
            }
        }
        update daScrivere;
    }
}
