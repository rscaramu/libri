public with sharing class GestoreCasi2
        extends GestoreTrigger {

    public static Integer esecuzioni = 0;

    protected override void primaModifica(
            List<sObject> nuovi, Map<Id, sObject> vecchi) {
        esecuzioni++;
        for (Case c : (List<Case>) nuovi) {
            c.Description = 'Elaborato';
        }
    }
}
