public with sharing class GestoreCasi
        extends GestoreTrigger {

    public static Integer esecuzioni = 0;

    protected override void dopoModifica(
            List<sObject> nuovi, Map<Id, sObject> vecchi) {
        esecuzioni++;
        List<Case> daScrivere = new List<Case>();
        for (Case c : (List<Case>) nuovi) {
            if (c.Description != 'Elaborato') {
                daScrivere.add(new Case(Id = c.Id,
                    Description = 'Elaborato'));
            }
        }
        update daScrivere;
    }
}
