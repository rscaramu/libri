public with sharing class MarcaturaSicura {

    @future
    public static void marca(List<Id> contatti) {
        try {
            List<Contact> daScrivere =
                new List<Contact>();
            for (Id chiave : contatti) {
                daScrivere.add(new Contact(Id = chiave,
                    Description = 'Elaborato'));
            }
            update daScrivere;
        } catch (Exception e) {
            Diario.errore('MarcaturaSicura.marca', e);
        }
    }
}
