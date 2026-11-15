public with sharing class Passaggi2 {

    private static Map<String, Set<Id>> trattati =
        new Map<String, Set<Id>>();

    public static List<sObject> nonAncoraTrattati(
            String regola, List<sObject> record) {
        if (!trattati.containsKey(regola)) {
            trattati.put(regola, new Set<Id>());
        }
        Set<Id> visti = trattati.get(regola);
        List<sObject> nuovi = new List<sObject>();
        for (sObject r : record) {
            if (!visti.contains(r.Id)) {
                visti.add(r.Id);
                nuovi.add(r);
            }
        }
        return nuovi;
    }
}
