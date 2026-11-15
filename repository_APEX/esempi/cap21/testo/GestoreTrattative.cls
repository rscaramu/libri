public with sharing class GestoreTrattative
        extends GestoreTrigger {

    protected override void primaInserimento(
            List<sObject> nuovi) {
        controllaImporti((List<Opportunity>) nuovi);
    }

    protected override void primaModifica(
            List<sObject> nuovi, Map<Id, sObject> vecchi) {
        controllaImporti((List<Opportunity>) nuovi);
    }

    protected override void dopoInserimento(
            List<sObject> nuovi) {
        ServizioTrattative.creaVerifiche(
            (List<Opportunity>) nuovi);
    }

    private void controllaImporti(
            List<Opportunity> trattative) {
        for (Opportunity o : trattative) {
            if (o.Amount != null && o.Amount < 0) {
                o.Amount.addError(
                    'L\'importo non puo\' essere negativo');
            }
        }
    }
}
