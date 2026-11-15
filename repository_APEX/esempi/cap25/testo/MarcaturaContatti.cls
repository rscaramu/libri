public with sharing class MarcaturaContatti {

    @future
    public static void marca(List<Id> contatti) {
        String adesso = Datetime.now()
            .format('dd/MM/yyyy HH:mm');
        List<Contact> daScrivere = new List<Contact>();
        for (Id chiave : contatti) {
            daScrivere.add(new Contact(Id = chiave,
                Description = 'Elaborato il ' + adesso));
        }
        Database.update(daScrivere, false);
    }
}
