public with sharing class GestoreLead
        extends GestoreTrigger {

    protected override void primaInserimento(
            List<sObject> nuovi) {
        for (Lead l : (List<Lead>) nuovi) {
            if (String.isBlank(l.Rating)) {
                l.Rating = 'Warm';
            }
        }
    }
}
