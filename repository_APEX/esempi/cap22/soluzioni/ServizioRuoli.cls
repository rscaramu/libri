public with sharing class ServizioRuoli {

    public static Integer aggiorna(
            Map<Id, String> ruoli) {
        List<Contact> daScrivere = new List<Contact>();
        for (Contact c : [SELECT Id, Title FROM Contact
                WHERE Id IN :ruoli.keySet()]) {
            String nuovo = ruoli.get(c.Id);
            if (c.Title != nuovo) {
                c.Title = nuovo;
                daScrivere.add(c);
            }
        }
        if (daScrivere.isEmpty()) {
            return 0;
        }
        GestoreTrigger.sospendi('GestoreContatti');
        try {
            update daScrivere;
        } finally {
            GestoreTrigger.riattiva('GestoreContatti');
        }
        return daScrivere.size();
    }
}
